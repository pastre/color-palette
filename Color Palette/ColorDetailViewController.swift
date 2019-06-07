//
//  ColorDetailViewController.swift
//  Color Palette
//
//  Created by Bruno Pastre on 06/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class ColorDetailViewController: UIViewController {

    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorCodeLabel: UILabel!
    @IBOutlet weak var likedButton: UIButton!
    
    let source = HarmonyProvider.instance
    
    var color: HSV!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colorView.layer.cornerRadius = self.colorView.frame.width  /  2
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.colorView.backgroundColor = color.getUIColor()
        if self.source.containsColor(self.color){
            self.likedButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        self.colorCodeLabel.text  = "#\(self.color.getDescriptiveHex())"
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
    }
    
    @IBAction func onTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
