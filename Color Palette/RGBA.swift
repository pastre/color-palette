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
    
}


class ColorPalette{
    
    var baseHSV: HSV!
    
    internal init(baseHSV: HSV?) {
        self.baseHSV = baseHSV
    }
    
    func getComplementaryPalette() -> [HSV]{
        let baseComp =  self.baseHSV.rotated(by: -180)
        
        let saturated = baseComp.saturated(by: 0.10)
        let saturatedComp = saturated.rotated(by: -180)
        
        let light = self.baseHSV.saturated(by: -0.10)
        let lightComp = light.rotated(by: -180)
        
        
        return [
            lightComp,
            light,
            baseComp,
            baseHSV,
            saturated,
            saturatedComp
        ]
    }

    func getMonochromatic() -> [HSV]{
        let saturation = self.baseHSV.saturation - 0.4 <= 0 ? self.baseHSV.saturation - 0.3 : self.baseHSV.saturation + 0.3
        return [
            HSV(hue: self.baseHSV.hue, saturation: self.baseHSV.saturation, value: 0.5),
            HSV(hue: self.baseHSV.hue, saturation: saturation, value: 1),
            self.baseHSV,
            HSV(hue: self.baseHSV.hue, saturation: saturation, value: 0.5),
            HSV(hue: self.baseHSV.hue, saturation: self.baseHSV.saturation, value: 0.8),
        ]
    }
    
    func getAnalogous() -> [HSV]{
        let angleOffset: CGFloat = 20.0
        let saturation = self.baseHSV.saturation < 0.05 ? 0.10 : self.baseHSV.saturation <= 0.95 ? self.baseHSV.saturation + 0.05 : 1 - (self.baseHSV.saturation - 95)
        let value = self.baseHSV.value <= 0.11 ? 0.20 : self.baseHSV.value < 0.92 ? self.baseHSV.value + 0.09 : self.baseHSV.value - 0.09
        
        let closeLeft = self.baseHSV.rotatedClockwise(by: angleOffset).withValue(value: value).withSaturation(saturation: saturation)
        let closeRight = self.baseHSV.rotatedAntiClockwise(by: angleOffset).withSaturation(saturation: saturation).withValue(value: value)
        
        let farLeft = self.baseHSV.rotatedClockwise(by: 2 * angleOffset).withValue(value: value).withSaturation(saturation: saturation)
        let farRight = self.baseHSV.rotatedAntiClockwise(by: 2 * angleOffset).withSaturation(saturation: saturation).withValue(value: value)
        
//        let closeLeft = HSV(hue: self.baseHSV, saturation: <#T##CGFloat?#>, value: <#T##CGFloat?#>)
        return [
            farLeft,
            closeLeft,
            baseHSV,
            closeRight,
            farRight
        ]
    }
    
    func getTriad() -> [HSV]{
        let angleOffset: CGFloat = 120
        
        let darker = HSV(hue: self.baseHSV.hue, saturation: self.baseHSV.saturation + (self.baseHSV.saturation <= 0.9 ? 0.10 : -0.10), value: self.baseHSV.value + (self.baseHSV.value >= 0.50 ? -0.30 : 0.30) )
        let right = self.baseHSV.rotatedAntiClockwise(by: angleOffset)
        let left = self.baseHSV.rotatedClockwise(by: angleOffset)
        let darkerLeft = left.withValue(value: left.value - 0.10)
        return [
            darker,
            right,
            self.baseHSV,
            left,
            darkerLeft
        ]
    }
    
//    func getTriad() -> [HSV] {
//        /*
//         formula: H1 = |(H0 + 120 degrees) - 360 degrees|
//         formula: H2 = |(H0 + 240 degrees) - 360 degrees|
//        */
//
//        return [
//            self.baseHSV.rotated(by: <#T##CGFloat#>)
//            self.baseHSV
//        ]
//
//
//    }
    
    
}
