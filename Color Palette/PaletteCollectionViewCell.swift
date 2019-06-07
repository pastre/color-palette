//
//  PaletteCollectionViewCell.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class PaletteCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        cell.backgroundColor = color.getUIColor()
        cell.color = color
        return cell
    }
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorsCollectionView: UICollectionView!
    var palette: Palette!
    
    func setupCell(){
        self.colorsCollectionView.delegate = self
        self.colorsCollectionView.dataSource = self
//        self.nameLabel.text = self.palette.name
    }
}
