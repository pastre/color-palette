//
//  PaletteCollectionViewCell.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class PaletteCollectionViewCell: BaseColorCollectionViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var colorsStackView: UIStackView!
    @IBOutlet weak var nameLabel: UITextField!
    
    var palette: Palette!
    
    override func setupCell(){
        super.setupCell()
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
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HarmonyProvider.instance.updatePalette(palette: self.palette, name: textField)
        textField.resignFirstResponder()
//        textField.endEditing(true)
        return true
    }
    
    override func onShare() {
        self.delegate?.onShare(sender: self.palette)
    }
}
