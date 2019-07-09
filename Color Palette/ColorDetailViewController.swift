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

    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorCodeLabel: UILabel!
    @IBOutlet weak var likedButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    let source = HarmonyProvider.instance
    
    var color: HSV!
    var displaysBlur: Bool! = false
    
    var delegate: ColorFavoriteDelegate?
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
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
        self.colorView.layer.cornerRadius = self.colorView.layer.frame.width  /  2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Frame width is", self.colorView.layer.frame.width)
    }
    
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
