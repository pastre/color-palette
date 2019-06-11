//
//  PaletteCollectionViewCell.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class PaletteCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UITextField!
    
    var palette: Palette!
    var delegate: ShareDelegate?
    
    func setupCell(){
        self.colorsCollectionView.delegate = self
        self.colorsCollectionView.dataSource = self
        self.nameLabel.delegate = self
        self.nameLabel.text = self.palette.name
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        self.delegate?.onSharePressed(sender: self.palette!)
    }
    
    // MARK: - Collection view delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.palette.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! BaseColorCollectionViewCell
        let color = self.palette.colors[indexPath.item]
        cell.layer.cornerRadius = cell.frame.width / 2
//        cell.layer.borderWidth = 2
//        cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = color.getUIColor()
        cell.color = color
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        HarmonyProvider.instance.updatePalette(palette: self.palette, name: textField)
        return true
    }
}
