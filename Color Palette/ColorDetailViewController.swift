//
//  ColorDetailViewController.swift
//  Color Palette
//
//  Created by Bruno Pastre on 06/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

protocol ColorFavoriteDelegate {
    func onFavoriteChanged()
}

class ColorDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorCodeLabel: UILabel!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet var colorCodeLongPressGestureRecognizer: UILongPressGestureRecognizer!
    
    // MARK: - Class variables
    let source = HarmonyProvider.instance
    
    var color: HSV!
    var displaysBlur: Bool! = false
    
    var delegate: ColorFavoriteDelegate?
    
    // MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapGestureRecognizer.shouldRequireFailure(of: self.panGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.colorView.backgroundColor = color.getUIColor()
        if self.source.containsColor(self.color){
            self.likedButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        self.colorCodeLabel.text  = "#\(self.color.getDescriptiveHex())"
        self.blurView.isHidden = false
        print("Frame width is", self.colorView.layer.frame.width)
        self.colorView.layer.cornerRadius = self.colorView.layer.frame.width  /  2
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.colorView.layer.cornerRadius = self.colorView.layer.frame.width  /  2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }

    // MARK: -  Helper methods
    
    func copyColorToClipboard(){
        UIPasteboard.general.string = self.color.getDescriptiveHex()
        UIView.animate(withDuration: 1, animations: {
            self.colorCodeLabel.alpha = 0.4
            self.colorCodeLabel.transform = self.colorCodeLabel.transform.scaledBy(x: 0.5, y: 0.5)
            self.colorCodeLabel.text = "Copied!"
            self.colorCodeLabel.transform = .identity
            self.colorCodeLabel.alpha = 1
        }) { (_) in
            
            self.colorCodeLabel.text  = "#\(self.color.getDescriptiveHex())"
            
        }
    }

    
    // MARK: - Callback functions
    
    @IBAction func onFavorite(_ sender: Any) {
        
        if self.color.isFavorite{
            self.likedButton.setImage(UIImage(named: "heartOutline"), for: .normal)
            self.color.isFavorite = false
        }else{
            self.likedButton.setImage(UIImage(named: "heart"), for: .normal)
            self.color.isFavorite = true
        }
        
        self.source.updateColors(with: self.color)
        self.delegate?.onFavoriteChanged()
    }
    
    @IBAction func onTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCodeLongPressed(_ sender: Any) {
        if self.colorCodeLongPressGestureRecognizer.state == .began{
            self.copyColorToClipboard()
        }
    }
        //    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
