//
//  ColorCollectionViewCell.swift
//  Color Palette
//
//  Created by Bruno Pastre on 06/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

protocol ShareDelegate{
    func onSharePressed(sender: Any)
}

class ColorCollectionViewCell: BaseColorCollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var hexCodeLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!

    var delegate: ShareDelegate?
    
    func setupCell(){
        self.hexCodeLabel.adjustsFontSizeToFitWidth = true
        self.redLabel.adjustsFontSizeToFitWidth = true
        self.greenLabel.adjustsFontSizeToFitWidth = true
        self.blueLabel.adjustsFontSizeToFitWidth = true
        
        self.colorView.backgroundColor = self.color.getUIColor()
        self.colorView.layer.cornerRadius = self.colorView.frame.width / 2
        self.colorView.clipsToBounds = true
        self.hexCodeLabel.text = "#\(self.color.getDescriptiveHex())"
        
        let rgb = RGB(fromHSV: self.color)
        
        self.redLabel.text = "R: \(String(format: "%.2f", rgb.red))"
        self.greenLabel.text = "G: \(String(format: "%.2f", rgb.green))"
        self.blueLabel.text = "B: \(String(format: "%.2f", rgb.blue))"
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        self.delegate?.onSharePressed(sender: self)
    }
    
}
 
