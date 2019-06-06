//
//  HSV.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class HSV{
    
    var hue: CGFloat!
    var saturation: CGFloat!
    var value: CGFloat!
    
    
    internal init(hue: CGFloat?, saturation: CGFloat?, value: CGFloat?) {
        self.hue = hue
        self.saturation = saturation
        self.value = value
    }
    
    init(from rgb: RGB){
        self.hue = self.getHue(from: rgb)
        self.saturation = self.getSaturation(from: rgb)
        self.value = rgb.getMax()
    }
    
    func rotated(by degrees: CGFloat) -> HSV{
        return HSV(hue: self.hue + degrees < 0 ? (self.hue + degrees) + 360 : self.hue + degrees, saturation: self.saturation, value: self.value)
    }
    
    func rotatedClockwise(by degrees: CGFloat) -> HSV{
        return HSV(hue: self.hue - degrees < 0 ? (self.hue - degrees) + 360 : self.hue - degrees, saturation: self.saturation, value: self.value)
    }
    
    func rotatedAntiClockwise(by degrees: CGFloat) -> HSV{
        return HSV(hue: self.hue + degrees > 360 ? (self.hue + degrees).truncatingRemainder(dividingBy: 360) : self.hue + degrees , saturation: self.saturation, value: self.value)
    }
    
    func saturated(by offset: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: self.saturation + offset, value: self.value)
    }
    
    func valued(by value: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: self.saturation, value: self.value + value)
    }
    
    func withRotation(angle: CGFloat) -> HSV{
        return HSV(hue: angle, saturation: self.saturation, value: self.value)
    }
    func withSaturation(saturation: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: saturation, value: self.value)
    }
    func withValue(value: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: self.saturation, value: value)
    }
    //
    func getSaturation(from rgb: RGB) -> CGFloat {
        let max = rgb.getMax(), min = rgb.getMin()
        return CGFloat((max - min) / max)
    }
    func getHue(from rgb: RGB) -> CGFloat{
        var r: CGFloat, g: CGFloat, b: CGFloat
        (r, g, b) = rgb.unpack()
        let max = rgb.getMax()
        let min = rgb.getMin()
        
        if g > r && g > b {
            return CGFloat( (60 * (b - r) / (max - min)) + 120 )
        }
        
        if b > g && b > r {
            return CGFloat( (60 * (r - g) / (max - min)) + 240 )
        }
        
        if g >= b{
            return CGFloat( (60 * (g - b) / (max - min))  )
        }
        
        return CGFloat( (60 * (g - b) / (max - min)) + 360)
    }
    func getUIColor() -> UIColor{
        return UIColor(hue: self.hue / 360, saturation: self.saturation, brightness: self.value, alpha: 1)
    }
    
    
    func asCircularView(radius ballRadius: CGFloat = 50) -> UIView{
        //        let ballRadius:  = 50
        let ballView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        //                ballView.clipsToBounds = true
        ballView.backgroundColor = self.getUIColor()
        ballView.layer.cornerRadius = ballRadius / 2
        
        //  TODO: COLOCAR A LARGURA IGUAL A ALTURA
        ballView.translatesAutoresizingMaskIntoConstraints = false
        ballView.widthAnchor.constraint(equalToConstant: ballRadius).isActive = true
        //                ballView.heightAnchor.constraint(equalToConstant: ballRadius).isActive = true
        ballView.heightAnchor.constraint(equalTo: ballView.widthAnchor).isActive = true
        
        return ballView
    }
    
}
