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
import AudioToolbox

extension MTKView : RenderDestinationProvider {
    
}

enum Harmony{
    case mono
    case analog
    case comp
    case triad
}

class ExploreViewController: UIViewController, MTKViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var savedView: UIView!
    @IBOutlet weak var colorsStackView: UIStackView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var paletteSegmentedControl: UISegmentedControl!
    
    var session: ARSession!
    var renderer: Renderer!
    var currentDrawable:  CAMetalDrawable!
    var square: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
    
    var presentingData: [HSV]! = [HSV]()
    
    var currentColor: HSV!
    var currentHarmony: Harmony!
    
    var colorPickerImageView = UIImageView(image: UIImage(named: "colorPicker"))
    
    let source = HarmonyProvider.instance
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        self.savedView.alpha = 0
        // Set the view's delegate
        self.currentHarmony = .mono
        self.currentColor = HSV(hue: 126, saturation: 0.8, value: 0.9)
        
        session = ARSession()
        session.delegate = self
//        session.configuration
        
        // Set the view to use the default device
        if let view = self.cameraView as? MTKView {
            view.device = MTLCreateSystemDefaultDevice()
            view.backgroundColor = UIColor.clear
            view.delegate = self
            
            guard view.device != nil else {
                print("Metal is not supported on this device")
                return
            }
//            view.orien
            // Configure the renderer to draw to the view
            renderer = Renderer(session: session, metalDevice: view.device!, renderDestination: view)
            renderer.drawRectResized(size: view.bounds.size)
        }
                self.setupSegmented()
        self.setupSquare()
        
        self.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let randomColor = HSV(hue: CGFloat.random(in: 0...360), saturation: CGFloat.random(in: 0...1), value: CGFloat.random(in: 0...1))
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        

        // Run the view's session
        session.run(configuration)
        
        self.square.center = self.view.center
        self.square.backgroundColor = randomColor.getUIColor()
        self.updateColor(to: randomColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        session.pause()
    }
   
//    override var canBecomeFirstResponder: Bool{
//        return true
//    }
    
    func setupSquare(){
        
        square.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.3612787724, alpha: 1)
        square.layer.cornerRadius = square.bounds.width / 2
        square.layer.borderWidth = 0
//        square.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.3612787724, alpha: 1)
        //        self.view.addSubview(square)
        self.view.insertSubview(self.square, belowSubview: self.overlayView)

        
        colorPickerImageView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerImageView.contentMode = .scaleAspectFit
        self.square.addSubview(colorPickerImageView)
        
        colorPickerImageView.centerXAnchor.constraint(equalTo: self.square.centerXAnchor).isActive = true
        colorPickerImageView.centerYAnchor.constraint(equalTo: self.square.centerYAnchor).isActive = true
        colorPickerImageView.widthAnchor.constraint(equalTo: self.square.widthAnchor, multiplier: 0.4).isActive = true
        colorPickerImageView.heightAnchor.constraint(equalTo: self.square.heightAnchor, multiplier: 0.4).isActive = true
    }
    
    func setupSegmented(){
        let clearColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        var selectedColor = #colorLiteral(red: 0.08908683807, green: 0.40617612, blue: 0.8853955865, alpha: 1)
        var defaultColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.paletteSegmentedControl.backgroundColor = clearColor
        self.paletteSegmentedControl.tintColor = clearColor
        self.paletteSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.backgroundColor : clearColor, NSAttributedString.Key.foregroundColor: defaultColor], for: .normal)
        
        
        self.paletteSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.backgroundColor : clearColor, NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }

    // MARK: - Color logic
    func updateTouch(touch: UITouch){
        let pos = touch.location(in: self.view)
        if !self.cameraView.bounds.contains(pos) { return }
        guard let rgb = self.getColor(x: pos.x, y: pos.y) else { return }
        let hsv = HSV(from: rgb)
        
        self.square.center = pos
        self.square.backgroundColor = hsv.getUIColor()
        self.updateColor(to: hsv)
//        self.presentingData = palletes.getComplementaryPalette()
//        self.presentingData = palletes.getAnalogous()
//        print("Complementary", complementary.h, complementary.s, complementary.v)
        
    }
    
    func updateColor(to hsv: HSV){
        
        self.currentColor = hsv
        
        let comp = PaletteGenerator(baseHSV: hsv).getTriad()[0]
       
        self.colorPickerImageView.image = UIImage(named: "colorPicker")!.maskWithColor(color: comp.getUIColor())
        self.square.layer.borderColor = comp.getUIColor().cgColor
        self.updatePresentingPalette()
    }
    
    // Updates the stackView
    func updatePresentingPalette(){
        let palettes = PaletteGenerator(baseHSV: self.currentColor)
        
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
        
        while self.colorsStackView.arrangedSubviews.count != 0{
            self.colorsStackView.arrangedSubviews.first!.removeFromSuperview() // Thanks @Ailton
//            self.colorsStackView.removeArrangedSubview(self.colorsStackView.arrangedSubviews.first!)
        }
        
        for color in self.presentingData{
            let ballView = color.asCircularView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap(_:)))
            
//            ballView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            ballView.layer.borderWidth = 1
//            
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            
            doubleTap.delegate = self
            doubleTap.numberOfTapsRequired = 2
            
            ballView.addGestureRecognizer(tap)
            ballView.addGestureRecognizer(doubleTap)
            tap.require(toFail: doubleTap)
            self.colorsStackView.addArrangedSubview(ballView)
        }
        
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
            let _: CGFloat = CGFloat(pixel[3]) / 255.0
            print("RED", pixel[2])
            print("GREEN", pixel[1])
            print("BLUE", pixel[0])
            print("RGB",red, green, blue)
            return RGB(red: red, green: green, blue: blue)
        }
        return nil
    }
   
    // MARK: - Callbacks
   
    @objc func onTap(_ sender: Any?){
        let tap = sender as! UITapGestureRecognizer
        let view = tap.view as! BallView
        let color = view.hsv
        
        self.performSegue(withIdentifier: "detailSegue", sender: color)
        
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.savePallete()
    }
    
    @IBAction func onNavigate(_ sender: Any) {
        
    }
    @objc func onDoubleTap(_ sender: Any?){
        
        let tap = sender as! UITapGestureRecognizer
        let view = tap.view as! BallView
        let color = view.hsv!
        
        self.updateColor(to: color)
        
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.savePallete()
            print("shake")
        }
    }
    
    func savePallete(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        self.source.addPalette(colors: self.presentingData)
        UIView.animate(withDuration: 0.5, animations: {
            self.colorsStackView.transform = self.colorsStackView.transform.scaledBy(x: 1.5, y: 1.5)
            self.colorsStackView.alpha = 0
            self.savedView.alpha = 1
        }) { (_) in
            generator.impactOccurred()
            self.colorsStackView.alpha = 1
            self.colorsStackView.transform = .identity
            
            UIView.animate(withDuration: 1, animations: {
                self.savedView.alpha = 0
            })
        }
        
        
        
    }
    
    // MARK: - MTKViewDelegate
    
    // Called whenever view changes orientation or layout is changed
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
//        renderer.drawRectResized(size: size)
    }
    
    // Called whenever the view needs to render
    func draw(in view: MTKView) {
        renderer.update()
        view.framebufferOnly = false
        //        view.transform = view.transform.rotated(by: CGFloat.pi / 2)
        self.currentDrawable = view.currentDrawable
        
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
    

    
    // MARK: - Touch overrides

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        for t in touches{
//            self.updateColor(touch: t)
//        }
//    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesMoved(touches, with: event)
        for t in touches{
            self.updateTouch(touch: t)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            let dest = segue.destination as! ColorDetailViewController
            dest.color = (sender as! HSV)
        }
    }
}


extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    
}
