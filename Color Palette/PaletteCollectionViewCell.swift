//
//  PaletteCollectionViewCell.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class PaletteCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var colorsStackView: UIStackView!
    @IBOutlet weak var nameLabel: UITextField!
    
    var palette: Palette!
    var delegate: ShareDelegate?
    
    func setupCell(){
        self.nameLabel.delegate = self
        self.nameLabel.text = self.palette.name
        self.setupStack()
        
        self.nameLabel.addTarget(self, action: #selector(self.edited) , for:UIControl.Event.editingChanged)

    }
    
    @objc func edited() {
        print("Edited \(self.nameLabel.text)")
        HarmonyProvider.instance.updatePalette(palette: self.palette, name: self.nameLabel)
    }
    
    func setupStack(){
        while self.colorsStackView.arrangedSubviews.count != 0{
            self.colorsStackView.arrangedSubviews.first!.removeFromSuperview()
        }
        
        for color in self.palette.colors{
            let ballView = color.asCircularView()
            self.colorsStackView.addArrangedSubview(ballView)
        }
    }
    
    @IBAction func onShare(_ sender: Any) {
        self.delegate?.onSharePressed(sender: self.palette!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HarmonyProvider.instance.updatePalette(palette: self.palette, name: textField)
        textField.resignFirstResponder()
//        textField.endEditing(true)
        return true
    }
}
