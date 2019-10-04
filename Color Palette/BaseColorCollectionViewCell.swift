
//
//  BaseColorCollectionViewCell.swift
//  Color Palette
//
//  Created by Bruno Pastre on 07/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

class BaseColorCollectionViewCell: UICollectionViewCell {
    
    var isDeleting: Bool!  = false
    var delegate: PaletteCellDelegate?
    @IBOutlet weak var shareButton: UIButton!
    
    func setupCell(){
        if self.isDeleting{
            self.shareButton.setImage(UIImage(named: "delete"), for: .normal)
        } else {
            self.shareButton.setImage(UIImage(named: "share"), for: .normal)
        }
    }
    
    @IBAction func onShare(_ sender: Any) {
        if self.isDeleting{
            self.onDelete()
        } else {
            self.onShare()
        }
    }
    
    func onShare(){
        self.delegate?.onShare(sender: self)
    }
    
    func onDelete(){
        self.delegate?.onDelete(sender: self)
    }
}
