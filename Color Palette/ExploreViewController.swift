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

enum UIOverlayState{
//    case compact
    case normal
    case expanded
    
    var opposite: UIOverlayState {
        switch self {
        case .normal: return .expanded
        case .expanded: return .normal
        }
    }
}

enum UIOptionsState{
    case open
    case closed
}

class ExploreViewController: UIViewController, MTKViewDelegate, ARSessionDelegate, UIGestureRecognizerDelegate, ColorFavoriteDelegate {

    //MARK: - Singletons
    let source = HarmonyProvider.instance
    let tutorialController = TutorialController.instance
    
    //MARK: - Outlet references
    @IBOutlet weak var colorsStackView: UIStackView!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var paletteSegmentedControl: UISegmentedControl!
    @IBOutlet weak var colorCollectionViewContainer: UIView!
    @IBOutlet weak var addPaletteButton: UIButton!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var saveLabel: UILabel!
    
    // MARK: - Constraint outlet
    @IBOutlet weak var overlayBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var palettesSegmentedTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var palettesSegmentedBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - UI control variables
    var uiState: UIOverlayState!
    var optionsState: UIOptionsState!
    var isCompact: Bool!
    
    // MARK: - Zoom views
    var zoomedImageView: UIImageView?
    var zoomView: UIView?
    var pointerView: UIView?
    
    // MARK: - Frame capturing related variables
    var session: ARSession!
    var cameraRenderer: Renderer!
    var currentDrawable:  CAMetalDrawable!
    
    // MARK: - View references
    var colorPickerCircle: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 75))
    var colorPickerImageView = UIImageView(image: UIImage(named: "colorPicker"))
    var colorsCollectionView: ColorsViewController!
    
    // MARK: - Palette and color state variables
    var presentingPalette: [HSV]! = [HSV]()
    var currentColor: HSV!
    var currentHarmony: Harmony!
    
    var animator: UIViewPropertyAnimator!
    
    // MARK: - Constraint animated related
    var transitionAnimator: UIViewPropertyAnimator!
    var animationProgress: CGFloat = 0
    lazy var DEFAULT_BOTTOM_CONSTANT: CGFloat = -(self.colorCollectionViewContainer.frame.height + 20)
    lazy var EXPANDED_BOTTOM_CONSTRAINT: CGFloat =   -10
    lazy var COMPACT_BOTTOM_CONSTANT: CGFloat = self.DEFAULT_BOTTOM_CONSTANT - (self.paletteSegmentedControl.frame.height +  self.addPaletteButton.frame.height + 60)
    lazy var MAX_ANIMATION_BOTTOM_CONSTANT: CGFloat = self.DEFAULT_BOTTOM_CONSTANT + 30
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge{
        return .bottom
    }
    
    
    // MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiState =  .expanded
        self.isCompact = false
        self.optionsState = .open
        
        self.currentHarmony = .mono
        self.currentColor = HSV(hue: 126, saturation: 0.8, value: 0.9)
        
        session = ARSession()
        session.delegate = self
        
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
            cameraRenderer = Renderer(session: session, metalDevice: view.device!, renderDestination: view)
            cameraRenderer.drawRectResized(size: self.view.bounds.size)
        }
        
        self.setupSegmented()
        self.setupSquare()
        self.setupGestures()
        self.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateiCloud), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: NSUbiquitousKeyValueStore.default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        

        // Run the view's session
        session.run(configuration)
        
        self.colorPickerCircle.center = self.view.center
        
        self.setNeedsUpdateOfHomeIndicatorAutoHidden()
        self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let randomColor = HSV(hue: CGFloat.random(in: 0...360), saturation: CGFloat.random(in: 0.1...1), value: CGFloat.random(in: 0.1...1))
        self.updateUIState(to: .normal)
        self.colorPickerCircle.backgroundColor = randomColor.getUIColor()
        self.updateColor(to: randomColor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        session.pause() 
    }
    
    func setupOverlayTutorial(){
        self.tutorialController.tutorial.isAnimating = true
//        let a =  UIViewPropertyAnimator(
//        self.animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut){
//            self.overlayView.transform = self.overlayView.transform.translatedBy(x: 0, y: -40)
//        }
//        
//        self.animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat, .transitionCurlUp, .curveEaseInOut, .allowUserInteraction], animations: {
//            self.overlayView.transform = self.overlayView.transform.translatedBy(x: 0, y: -40)
//        }, completion: { (_) in
//            self.overlayView.transform = .identity
//        })
//        self.animator.startAnimation()
        UIView.animate(withDuration: 0.2, delay: 0, options: [.transitionCurlUp, .curveEaseOut, .allowUserInteraction], animations: {
            self.overlayView.transform = self.overlayView.transform.translatedBy(x: 0, y: -140)
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.3, options: [.transitionCurlDown, .curveEaseIn, .allowUserInteraction], animations: {
                
                self.overlayView.transform = .identity
            }, completion: { _ in
                
            })
        }
    }
    
    func setupGestures(){
        
        let overlayPan = UIPanGestureRecognizer(target: self, action: #selector(self.onOverlayPan(_:)))
        overlayPan.delegate =  self
        self.overlayView.addGestureRecognizer(overlayPan)
        
        let colorPan = UIPanGestureRecognizer(target: self, action: #selector(self.onViewPanned(_:)))
        self.cameraView.addGestureRecognizer(colorPan)
        colorPan.require(toFail: overlayPan)
    }
    
    func setupSquare(){
        
        colorPickerCircle.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.3612787724, alpha: 1)
        colorPickerCircle.layer.cornerRadius = colorPickerCircle.bounds.width / 2
        colorPickerCircle.layer.borderWidth = 0
//        square.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.3612787724, alpha: 1)
        //        self.view.addSubview(square)
        self.cameraView.addSubview(self.colorPickerCircle)

        
        colorPickerImageView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerImageView.contentMode = .scaleAspectFit
        self.colorPickerCircle.addSubview(colorPickerImageView)
        
        colorPickerImageView.centerXAnchor.constraint(equalTo: self.colorPickerCircle.centerXAnchor).isActive = true
        colorPickerImageView.centerYAnchor.constraint(equalTo: self.colorPickerCircle.centerYAnchor).isActive = true
        colorPickerImageView.widthAnchor.constraint(equalTo: self.colorPickerCircle.widthAnchor, multiplier: 0.4).isActive = true
        colorPickerImageView.heightAnchor.constraint(equalTo: self.colorPickerCircle.heightAnchor, multiplier: 0.4).isActive = true
        
        self.view.bringSubviewToFront(self.overlayView)
        self.cameraView.bringSubviewToFront(self.overlayView)
    }
    
    func setupSegmented(){
        let clearColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        let clearImage = UIImage.render(size: CGSize(width: 2, height: 29), {UIColor.clear.setFill()})
        var selectedColor = #colorLiteral(red: 0.08908683807, green: 0.40617612, blue: 0.8853955865, alpha: 1)
        var defaultColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.paletteSegmentedControl.backgroundColor = clearColor
        self.paletteSegmentedControl.tintColor = clearColor
        
        self.paletteSegmentedControl.setDividerImage(clearImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        self.paletteSegmentedControl.setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        
        self.paletteSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.backgroundColor : clearColor, NSAttributedString.Key.foregroundColor: defaultColor], for: .normal)
        self.paletteSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.backgroundColor : clearColor, NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
    }

    
    
    // MARK: - Color logic
    func updateColorPosition(to point: CGPoint){
        if !self.cameraView.bounds.contains(point) { return }
        guard let rgb = self.getColor(x: point.x, y: point.y) else { return }
        let hsv = HSV(from: rgb)
        
        self.colorPickerCircle.center = point
        self.colorPickerCircle.backgroundColor = hsv.getUIColor()
        self.updateColor(to: hsv)
        
    }
    
    func updateTouch(touch: UITouch){
        let pos = touch.location(in: self.view)
        self.updateColorPosition(to: pos)
//        self.presentingData = palletes.getComplementaryPalette()
//        self.presentingData = palletes.getAnalogous()
//        print("Complementary", complementary.h, complementary.s, complementary.v)
        
    }
    
    func updateColor(to hsv: HSV){
        
        self.currentColor = hsv
        
        let comp = PaletteGenerator(baseHSV: hsv).getTriad()[0]
       
        self.colorPickerImageView.image = UIImage(named: "colorPicker")!.maskWithColor(color: comp.getUIColor())
        self.colorPickerCircle.layer.borderColor = comp.getUIColor().cgColor
        self.updatePresentingPalette()
    }
    
    // Updates the stackView
    func updatePresentingPalette(){
        let palettes = PaletteGenerator(baseHSV: self.currentColor)
        
        switch self.currentHarmony! {
        case .mono:
            self.presentingPalette = palettes.getMonochromatic()
        case .analog:
            self.presentingPalette = palettes.getAnalogous()
        case .comp:
            self.presentingPalette = palettes.getComplementaryPalette()
        case .triad:
            self.presentingPalette = palettes.getTriad()
            
        }
        
        while self.colorsStackView.arrangedSubviews.count != 0{
            self.colorsStackView.arrangedSubviews.first!.removeFromSuperview() // Thanks @Ailton
//            self.colorsStackView.removeArrangedSubview(self.colorsStackView.arrangedSubviews.first!)
        }
        
        for (i, color) in self.presentingPalette.enumerated(){
            var ballView : UIView!
//            if i - 1  == (self.presentingPalette.count % 2  == 0  ? self.presentingPalette.count : self.presentingPalette.count + 1) / 2{
//                ballView = color.asCircularView(radius: 60)
//            }else{
//                ballView = color.asCircularView(radius: 55)
//            }
            if i  == 2{
                ballView = color.asCircularView(radius: (0.072 * self.cameraView.frame.height) + 5)
            }else{
                ballView = color.asCircularView(radius: 0.072 * self.cameraView.frame.height)
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)))
//            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap(_:)))
            let doubleTap = UILongPressGestureRecognizer(target: self, action: #selector(self.onDoubleTap(_:)))
//            ballView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            ballView.layer.borderWidth = 1
//            
            tap.delegate = self
            tap.numberOfTapsRequired = 1
            
            doubleTap.delegate = self
//            doubleTap.numberOfTapsRequired = 1
            doubleTap.allowableMovement = 60
            doubleTap.minimumPressDuration = TimeInterval(0.5)
            doubleTap.delaysTouchesBegan = false
            doubleTap.delaysTouchesEnded = true
            doubleTap.isEnabled = true
            doubleTap.cancelsTouchesInView = true
            
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
            
            curDrawable.texture.getBytes(&pixel, bytesPerRow: bytesPerRow, from: MTLRegionMake2D(Int(x * textureScale), Int(y * textureScale), 1, 1), mipmapLevel: 0)
            let red: CGFloat   = CGFloat(pixel[2]) / 255.0
            let green: CGFloat = CGFloat(pixel[1]) / 255.0
            let blue: CGFloat  = CGFloat(pixel[0]) / 255.0
            let _: CGFloat = CGFloat(pixel[3]) / 255.0
            
            return RGB(red: red, green: green, blue: blue)
        }
        
        return nil
    }
   
    // MARK: - Color changed delegate
    func onFavoriteChanged() {
        self.colorsCollectionView.collectionView.reloadData()
    }
    
    // MARK: - Zoom methods
    
    func setupZoomView() {
        let zoomView = UIView()
        let zoomedImageView = UIImageView()
        let pointerView = UIView()
        
        pointerView.translatesAutoresizingMaskIntoConstraints = false
        pointerView.backgroundColor = .black
        
        zoomedImageView.translatesAutoresizingMaskIntoConstraints = false
        zoomedImageView.contentMode = .scaleToFill
        zoomedImageView.clipsToBounds = true
        zoomedImageView.layer.cornerRadius = 32
        zoomedImageView.backgroundColor = .clear

        zoomView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        zoomView.backgroundColor = .clear
        zoomView.translatesAutoresizingMaskIntoConstraints = false
        zoomView.clipsToBounds = true
        zoomView.layer.cornerRadius = 32
        
        zoomView.addSubview(zoomedImageView)
        zoomView.addSubview(pointerView)
        
        zoomedImageView.centerYAnchor.constraint(equalTo: zoomView.centerYAnchor).isActive = true
        zoomedImageView.centerXAnchor.constraint(equalTo: zoomView.centerXAnchor).isActive = true
        zoomedImageView.widthAnchor.constraint(equalTo: zoomView.widthAnchor, multiplier: 0.9).isActive = true
        zoomedImageView.heightAnchor.constraint(equalTo: zoomedImageView.widthAnchor).isActive = true
        
        pointerView.centerYAnchor.constraint(equalTo: zoomView.centerYAnchor).isActive = true
        pointerView.centerXAnchor.constraint(equalTo: zoomView.centerXAnchor).isActive = true
        pointerView.widthAnchor.constraint(equalTo: zoomView.widthAnchor, multiplier: 0.1).isActive = true
        pointerView.heightAnchor.constraint(equalTo: pointerView.widthAnchor).isActive = true
        
        self.cameraView.addSubview(zoomView)
        
        zoomView.widthAnchor.constraint(equalTo: self.cameraView.widthAnchor, multiplier: 0.3).isActive = true
        zoomView.heightAnchor.constraint(equalTo: zoomView.widthAnchor).isActive = true
        zoomView.centerXAnchor.constraint(equalTo: self.cameraView.centerXAnchor).isActive = true
        zoomView.centerYAnchor.constraint(equalTo: self.cameraView.centerYAnchor).isActive = true
        
        self.zoomedImageView = zoomedImageView
        self.zoomView = zoomView
        self.pointerView = pointerView
        
        zoomView.transform = zoomView.transform.scaledBy(x: 0.00001, y: 0.00001)
        
        UIView.animate(withDuration: 0.5) {
            zoomView.transform = .identity
            self.colorPickerCircle.transform = self.colorPickerCircle.transform.scaledBy(x: 0.00001, y: 0.00001)
        }
        pointerView.layoutIfNeeded()
        pointerView.clipsToBounds = true
        pointerView.layer.cornerRadius = pointerView.frame.width / 2
        pointerView.layer.masksToBounds = true
        self.colorPickerCircle.removeFromSuperview()
    }
    
    func imageWithImage(image: UIImage, croppedTo rect: CGRect) -> UIImage {

        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y,
                              width: image.size.width, height: image.size.height)

        context?.clip(to: CGRect(x: 0, y: 0,
                                 width: rect.size.width, height: rect.size.height))

        image.draw(in: drawRect)

        let subImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        return subImage!
    }

    
    func updateZoomView(to point: CGPoint) {
//        var frame = CGRect(origin: point, size: CGSize(width: 10, height: 10))
//        let flowView = UIView(frame: frame)
//        flowView.backgroundColor = .red
//        self.cameraView.addSubview(flowView)
        guard let zoomView = self.zoomView else { return }
        guard let zoomedImageView = self.zoomedImageView else { return }
        guard let pointerView = self.pointerView else { return }
        
        let size: CGFloat = 60
        let texture = self.currentDrawable.texture
        let image = UIImage(texture: texture)
        
        var viewPoint = point
        let cropRect = CGRect(x: point.x - size / 2 , y: point.y - size / 2 , width: size, height: size)

        zoomedImageView.image = self.imageWithImage(image: image.imageWith(newSize: self.cameraView.frame.size), croppedTo: cropRect)

        viewPoint.y -= zoomView.frame.height / 2
        zoomView.center = viewPoint
        
        pointerView.backgroundColor = PaletteGenerator(baseHSV: self.currentColor).getTriad()[2].getUIColor()
        
    }
    
    func destroyZoomView() {
        guard let zoomView = self.zoomView else { return }
        
        
        UIView.animate(withDuration: 0.5) {
            self.colorPickerCircle.transform = .identity
            zoomView.transform = self.colorPickerCircle.transform.scaledBy(x: 0.00001, y: 0.00001)
        }
        
//        self.cameraView.addSubview(self.colorPickerCircle)
        self.setupSquare()
        zoomView.removeFromSuperview()
        
        self.zoomView = nil
        self.zoomedImageView = nil
    }
    
    // MARK: - Callbacks
    
    @objc func onViewPanned(_ sender: Any){
        let gesture = sender as! UIPanGestureRecognizer
        let pos = gesture.location(in: self.cameraView)
        if gesture.state == .began{
            self.transitionAnimator.stopAnimation(true)
            self.goCompact()
            self.setupZoomView()
            
        }else if gesture.state == .ended{
            self.leaveCompact()
            self.destroyZoomView()
        }
        //        if self.uiState != .normal{
        //            self.updateUIState(to: .normal, duration: 0.5)
        //        }
        self.updateColorPosition(to: pos)
        self.updateZoomView(to: pos)
    }
    
    @objc func onOverlayPan(_ sender: Any) {
        if !self.tutorialController.hasOpenedOverlay(){
//            self.animator.stopAnimation(false)
            self.overlayView.layer.removeAnimation(forKey: "transform")
            self.tutorialController.onOverlayOpened()
            self.overlayView.layoutIfNeeded()
        }
        if self.isCompact { return }
        let recognizer = sender as! UIPanGestureRecognizer
        switch recognizer.state {
        case .began:
            self.updateUIState(to: self.uiState.opposite)
            animationProgress = transitionAnimator.fractionComplete
            transitionAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self.view)
            var fraction = -translation.y / DEFAULT_BOTTOM_CONSTANT
            //            print("Fraction is", fraction,  translation)
            if self.uiState == .normal { fraction *= -1 }
            transitionAnimator.fractionComplete = fraction + animationProgress
        case .ended:
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }
    
   
    @objc func onTap(_ sender: Any?){
        let tap = sender as! UITapGestureRecognizer
        let view = tap.view as! BallView
        let color = view.hsv
        
        self.performSegue(withIdentifier: "detailSegue", sender: color)
        
    }
    
    @IBAction func onSave(_ sender: Any) {
        self.savePalette()
        
        if !self.tutorialController.hasOpenedOverlay(){
            self.setupOverlayTutorial()
        }
    }
    
    
    @objc func onDoubleTap(_ sender: Any?){
        let tap = sender as! UILongPressGestureRecognizer
        print("SENDER STATE IS", tap.state.rawValue)
        let view = tap.view as! BallView
        let color = view.hsv!
        
        if tap.state == .began{
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
        
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        print("keyboard will show!")
        
        // To obtain the size of the keyboard:
        let keyboardSize:CGSize = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        self.overlayBottomConstraint.constant = keyboardSize.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        self.overlayBottomConstraint.constant = -10
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func updateiCloud(){
        print("Chegou update do icloud")
    }
    
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.savePalette()
            print("shake")
        }
    }
    
    func savePalette(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        self.source.addPalette(colors: self.presentingPalette)
        self.saveLabel.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.colorsStackView.transform = self.colorsStackView.transform.scaledBy(x: 0.6, y: 0.6)
            self.colorsStackView.transform = self.colorsStackView.transform.translatedBy(x: 0, y: -20)
            self.colorsStackView.transform = self.colorsStackView.transform.scaledBy(x: 1.4, y: 1.4)
            self.colorsStackView.alpha = 0.8
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
                self.colorsStackView.transform  = self.colorsStackView.transform.translatedBy(x: 0, y: 300)
//                self.colorsStackView.transform  = self.colorsStackView.transform.scaledBy(x: 0.1, y: 1)
                self.colorsStackView.alpha = 0.2
            }, completion: { (_) in
                self.colorsStackView.alpha = 0
                generator.impactOccurred()
                self.colorsStackView.alpha = 1
                self.colorsStackView.transform = .identity
                self.saveLabel.isHidden = true
            })
            UIView.animate(withDuration: 1, animations: {
//                self.savedView.alpha = 0
            })  
        }
        
        self.colorsCollectionView.collectionView.reloadData()
        
    }

    //MARK: - Options control
    func displayOptions(){
        
    }
    
    func hideOptions(){
        
    }
    
    func updateOptionsState(to state: UIOptionsState){
        switch state {
        case .open:
            self.displayOptions()
        case .closed:
            self.hideOptions()
        }
    }
    
    // MARK: - Overlay control

    func goCompact(){
        UIView.animate(withDuration: 0.5, animations: {
            
            self.dragView.alpha = 0
            self.addPaletteButton.transform = self.addPaletteButton.transform.scaledBy(x: 1, y: 0)
            self.paletteSegmentedControl.transform = self.paletteSegmentedControl.transform.scaledBy(x: 1, y: 0)
            
            self.bottomConstraint.constant = self.COMPACT_BOTTOM_CONSTANT
            self.palettesSegmentedBottomConstraint.constant = -20
            self.dragViewTopConstraint.constant = 0
            self.palettesSegmentedTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.isCompact = true
        }
    }
    
    func leaveCompact(){
        UIView.animate(withDuration: 0.5, animations: {
            self.bottomConstraint.constant = self.DEFAULT_BOTTOM_CONSTANT
            self.palettesSegmentedBottomConstraint.constant = 0
            self.dragViewTopConstraint.constant = 10
            self.palettesSegmentedTopConstraint.constant = 10
            self.dragView.alpha = 1
            self.addPaletteButton.transform = .identity
            self.paletteSegmentedControl.transform = .identity
            
            self.view.layoutIfNeeded()
        }) { (_) in
            self.isCompact = false
        }
    }
    
    func updateUIState(to state: UIOverlayState, duration: TimeInterval = 1){
        
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .expanded:
                self.bottomConstraint.constant = self.EXPANDED_BOTTOM_CONSTRAINT
            case .normal:
                self.bottomConstraint.constant = self.DEFAULT_BOTTOM_CONSTANT
            }
            self.view.layoutIfNeeded()
            
//            #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        })
        
        transitionAnimator.addCompletion { position in
            
            switch position {
            case .start:
                self.uiState = state.opposite
            case .end:
                self.uiState = state
            case .current:
                ()
            }
            switch self.uiState {
            case .expanded?:
                self.bottomConstraint.constant = self.EXPANDED_BOTTOM_CONSTRAINT
            case .normal?:
                self.bottomConstraint.constant = self.DEFAULT_BOTTOM_CONSTANT
            case .none:
                break
            }
        }
        transitionAnimator.startAnimation()
        self.view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            let dest = segue.destination as! ColorDetailViewController
            dest.color = (sender as! HSV)
            dest.delegate = self
            if self.uiState == .expanded{
                dest.displaysBlur = true
            }
        } else if segue.identifier == "colorsCollectionView"{
            self.colorsCollectionView = segue.destination as! ColorsViewController
        }
    }
}


extension ExploreViewController{
    
    // MARK: - MTKViewDelegate
    
    // Called whenever view changes orientation or layout is changed
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //        renderer.drawRectResized(size: size)
    }
    
    // Called whenever the view needs to render
    func draw(in view: MTKView) {
        cameraRenderer.update()
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
    
}

extension UIImage {
    static func render(size: CGSize, _ draw: () -> Void) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        defer { UIGraphicsEndImageContext() }
        
        draw()
        
        return UIGraphicsGetImageFromCurrentImageContext()?
            .withRenderingMode(.alwaysTemplate)
    }
    
    static func make(size: CGSize, color: UIColor = .white) -> UIImage? {
        return render(size: size) {
            color.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }
    

    convenience init(texture: MTLTexture) {
      let bitsPerComponent = 8
      let bitsPerPixel = 32
        let bytesPerRow: UInt = UInt(texture.width * 4)
      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = [.byteOrder32Little, CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)]
      
        let cgim = CGImage(
            width: texture.width,
            height: texture.height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: Int(bytesPerRow),
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: UIImage.dataProviderRefFrom(texture: texture),
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent
          )
        self.init(cgImage: cgim!)
    }
    
    static func dataProviderRefFrom(texture: MTLTexture) -> CGDataProvider {
        let region = MTLRegionMake2D(0, 0, Int(texture.width), Int(texture.height))
        
        let pixelCount: Int = texture.width * texture.height
        
        var imageBytes = [UInt8](repeating: 0, count: pixelCount * 4)
        texture.getBytes(&imageBytes, bytesPerRow: 4 * texture.width, from: region, mipmapLevel: 0)
        
        let providerRef = CGDataProvider(data: NSData(bytes: &imageBytes, length: pixelCount * 4 * MemoryLayout<UInt8>.size ))
        return providerRef!
    }
    
    func imageWith(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let image = renderer.image { _ in
            self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
        }

        return image
    }
    
}
