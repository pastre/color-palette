//
//  Overlay.swift
//  Color Palette
//
//  Created by Bruno Pastre on 04/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import UIKit

@IBDesignable
class Overlay: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit(){
//        self.clipsToBounds = false
        self.layer.cornerRadius = 40
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
