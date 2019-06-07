//
//  ColorPalette.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class PaletteGenerator{
    
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
            //            baseComp,
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

