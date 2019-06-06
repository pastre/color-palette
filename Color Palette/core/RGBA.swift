//
//  RGBA.swift
//  Color Palette
//
//  Created by Bruno Pastre on 04/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class RGB{
    
    var red: CGFloat // [0,1]
    var green: CGFloat // [0,1]
    var blue: CGFloat // [0,1]
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    func getMax() -> CGFloat{
        if self.red >= self.green && self.red >= self.blue{
            return self.red
        }
        if self.green >= self.red && self.green >= self.blue {
            return self.green
        }
        
        return self.blue
    }
    
    func getMin() -> CGFloat{
        if self.red <= self.green && self.red <= self.blue{
            return self.red
        }
        if self.green <= self.red && self.green <= self.blue {
            return self.green
        }
        
        return self.blue
    }
    
    func unpack() -> (CGFloat, CGFloat, CGFloat){
        return (self.red, self.green, self.blue)
    }
//    func toHSV() -> HSV{
//        return HSV()
//    }
}

class RGBA: RGB{
    
    var alpha: CGFloat!
    
    internal init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat?) {
        super.init(red: red, green: green, blue: blue)
        self.alpha = alpha
    }
}




