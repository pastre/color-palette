//
//  ViewController.swift
//  Color Palette
//
//  Created by Bruno Pastre on 03/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit
import Metal
import MetalKit
import ARKit

extension MTKView : RenderDestinationProvider {
    
}

enum Harmony{
    case mono
    case analog
    case comp
    case triad
}

class ViewController: UIViewController, MTKViewDelegate, ARSessionDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presentingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "default", for: indexPath)
        let hsv = self.presentingData[indexPath.item]
//        print(hsv.h, hsv.s, hsv.v)
        cell.backgroundColor = hsv.getUIColor()
        return cell
    }
    
    
    @IBOutlet weak var debugView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var session: ARSession!
    var renderer: Renderer!
    var currentDrawable:  CAMetalDrawable!
    var square: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var presentingData: [HSV]! = [HSV]()
    
    var currentColor: HSV!
    var currentHarmony: Harmony!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        self.currentHarmony = .mono
        self.currentColor = HSV(hue: 126, saturation: 0.8, value: 0.9)
        session = ARSession()
        session.delegate = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Set the view to use the default device
        if let view = self.cameraView as? MTKView {
            view.device = MTLCreateSystemDefaultDevice()
            view.backgroundColor = UIColor.clear
            view.delegate = self
            
            guard view.device != nil else {
                print("Metal is not supported on this device")
                return
            }
            
            // Configure the renderer to draw to the view
            renderer = Renderer(session: session, metalDevice: view.device!, renderDestination: view)
            
            renderer.drawRectResized(size: view.bounds.size)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap(gestureRecognize:)))
        self.cameraView.addGestureRecognizer(tapGesture)
        square.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.3612787724, alpha: 1)
        square.layer.cornerRadius = square.bounds.width / 2
        self.view.addSubview(square)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        session.run(configuration)
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        session.pause()
    }
    
    func updateColor(touch: UITouch){
        let pos = touch.location(in: self.view)
        if !self.cameraView.bounds.contains(pos) { return }
        guard let rgb = self.getColor(x: pos.x, y: pos.y) else { return }
        let hsv = HSV(from: rgb)
        
        self.square.center = pos
        self.square.backgroundColor = hsv.getUIColor()
        self.currentColor = hsv
        self.updatePresentingPalette()
//        self.presentingData = palletes.getComplementaryPalette()
//        self.presentingData = palletes.getAnalogous()
//        print("Complementary", complementary.h, complementary.s, complementary.v)
        for h in self.presentingData{
            print("HSV", h.hue!, h.saturation!, h.value!)
        }
        print("------------ ")
        
    }
    
    func updatePresentingPalette(){
        let palettes = ColorPalette(baseHSV: self.currentColor)
        
        switch self.currentHarmony! {
        case .mono:
            self.presentingData = palettes.getMonochromatic()
        case .analog:
            self.presentingData = palettes.getAnalogous()
        case .comp:
            self.presentingData = palettes.getComplementaryPalette()
        case .triad:
            self.presentingData = palettes.getTriad()
            
        }
        
//        self.presentingData = palletes.getTriad()
        self.collectionView.reloadData()
    }
    
    @objc
    func handleTap(gestureRecognize: UITapGestureRecognizer) {
        // Create anchor using the camera's current position
//        let pos = gestureRecognize.location(in: self.view)
//        guard let color = self.getColor(x: pos.x, y: pos.y) else { return }
//        self.square.center = pos
//        self.square.backgroundColor = color
//        print("Pos is", pos)
//        let ci = CIColor(color: color)
//        color?.ciColor.colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
//        print("A cor vale", ci.red * 255, ci.green * 255, ci.blue * 255)
//        self.view.bringSubviewToFront(self.debugView)
//        self.debugView.backgroundColor = color
//        if let currentFrame = session.currentFrame {
//
//            // Create a transform with a translation of 0.2 meters in front of the camera
//            var translation = matrix_identity_float4x4
//            translation.columns.3.z = -0.2
//            let transform = simd_mul(currentFrame.camera.transform, translation)
//
//            // Add a new anchor to the session
//            let anchor = ARAnchor(transform: transform)
//            session.add(anchor: anchor)
//        }
    }
    
    // MARK: - MTKViewDelegate
    
    // Called whenever view changes orientation or layout is changed
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer.drawRectResized(size: size)
    }
    
    // Called whenever the view needs to render
    func draw(in view: MTKView) {
        renderer.update()
        view.framebufferOnly = false
//        view.transform = view.transform.rotated(by: CGFloat.pi / 2)
        self.currentDrawable = view.currentDrawable
        
    }
    
    
    func getColor(x: CGFloat, y: CGFloat) -> RGB? {
        
        if let curDrawable = self.currentDrawable {
            var pixel: [CUnsignedChar] = [0, 0, 0, 0]  // bgra
            
            let textureScale = CGFloat(curDrawable.texture.width) / self.cameraView.bounds.width
            let bytesPerRow = curDrawable.texture.width * 4
//            let y = self.cameraView.bounds.height - y
//            let y = 
            curDrawable.texture.getBytes(&pixel, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(Int(x * textureScale), Int(y * textureScale), 1, 1), mipmapLevel: 0)
            let red: CGFloat   = CGFloat(pixel[2]) / 255.0
            let green: CGFloat = CGFloat(pixel[1]) / 255.0
            let blue: CGFloat  = CGFloat(pixel[0]) / 255.0
            let alpha: CGFloat = CGFloat(pixel[3]) / 255.0
            print("RED", pixel[2])
            print("GREEN", pixel[1])
            print("BLUE", pixel[0])
            print("RGB",red, green, blue)
            return RGB(red: red, green: green, blue: blue)
        }
        return nil
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for t in touches{
            self.updateColor(touch: t)
        }
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    @IBAction func onSegmentedPicked(_ sender: Any) {
        let seg = sender as! UISegmentedControl
        
        switch seg.selectedSegmentIndex {
        case 0:
            self.currentHarmony = .mono
        case 1:
            self.currentHarmony = .analog
        case 2:
            self.currentHarmony = .comp
        case 3:
            self.currentHarmony = .triad
        default:
            break
        }
        self.updatePresentingPalette()
    }
}
