//
//  HSV.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class BallView: UIView {
    var hsv: HSV!
}



class HSV: NSObject, NSCoding, Serializable{
    required init(fromJSON: Data?) {
        
    }
    

    static let HUE_CEILING: CGFloat = 360
    static let HUE_FLOOR: CGFloat = 0
    
    var hue: CGFloat!
    var saturation: CGFloat!
    var value: CGFloat!
    var isFavorite: Bool!
    
    init(hue: CGFloat, saturation: CGFloat, value: CGFloat) {
        let message = "Failed to create color with parameters: \(hue), \(saturation), \(value)"
        
            // ASSERTIONS FOR DEBUGGING
//        assert(hue <= HSV.HUE_CEILING && hue >= HSV.HUE_FLOOR, message)
//        assert(saturation >= 0 && saturation <= 1, message)
//        assert(value >= 0 && value <= 1, message)
        self.hue = hue
        
        if saturation < 0 {
            self.saturation = 0
        }else if saturation > 1{
            self.saturation = 1
        }else{
            self.saturation = saturation
        }
        
        if value < 0 {
            self.value = 0
        }else if value > 1{
            self.value = 1
        }else {
            self.value = value
        }
        
        self.isFavorite = false
    }

    convenience init(from rgb: RGB){
        
        let hue = HSV.getHue(from: rgb)
        let saturation = HSV.getSaturation(from: rgb)
        let value = rgb.getMax()
        self.init(hue: hue, saturation: saturation, value: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hue = (aDecoder.decodeObject(forKey: "hue") as! CGFloat)
        self.saturation = (aDecoder.decodeObject(forKey: "saturation") as! CGFloat)
        self.value = (aDecoder.decodeObject(forKey: "value") as! CGFloat)
        self.isFavorite = (aDecoder.decodeObject(forKey: "isFavorite") as! Bool)
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
        return HSV(hue: self.hue, saturation: self.saturation + offset > 1 ? 1 : self.saturation + offset, value: self.value)
    }
    
    func valued(by value: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: self.saturation, value: self.value + value > 1 ? 1 : self.value + value)
    }
    
    func withRotation(angle: CGFloat) -> HSV{
        return HSV(hue: angle, saturation: self.saturation, value: self.value)
    }
    func withSaturation(saturation: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: saturation < 0 ? 0 : saturation, value: self.value)
    }
    func withValue(value: CGFloat) -> HSV{
        return HSV(hue: self.hue, saturation: self.saturation, value: value <  0 ? 0 : value )
    }
    //
   static func getSaturation(from rgb: RGB) -> CGFloat {
        let max = rgb.getMax(), min = rgb.getMin()
        return CGFloat((max - min) / max).isNaN ? CGFloat(0) : CGFloat((max - min) / max)
    }
    
    static func getHue(from rgb: RGB) -> CGFloat{
        var r: CGFloat, g: CGFloat, b: CGFloat
        (r, g, b) = rgb.unpack()
        let max = rgb.getMax()
        let min = rgb.getMin()
        
        var ret: CGFloat!
        if g > r && g > b {
            ret = CGFloat( (60 * (b - r) / (max - min)) + 120 )
        }else if b > g && b > r {
            ret = CGFloat( (60 * (r - g) / (max - min)) + 240 )
        }else if g >= b{
            ret = CGFloat( (60 * (g - b) / (max - min))  )
        }else if r == 0 && r == 0 && b == 0{
            ret = CGFloat(30)
        }else{
            ret =  CGFloat( (60 * (g - b) / (max - min)) + 360)
        }
        ret = ret.isNaN ? CGFloat(120) : ret
        assert(!ret.isNaN, "Deu NaN irmao")
        return ret
    }
    func getUIColor() -> UIColor{
        return UIColor(hue: self.hue / 360, saturation: self.saturation, brightness: self.value, alpha: 1)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hue, forKey: "hue")
        aCoder.encode(self.saturation, forKey: "saturation")
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.isFavorite, forKey: "isFavorite")
    }
    
    func asCircularView(radius ballRadius: CGFloat = 50) -> UIView{
        //        let ballRadius:  = 50
        let ballView = BallView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        //                ballView.clipsToBounds = true
        ballView.backgroundColor = self.getUIColor()
        ballView.layer.cornerRadius = ballRadius / 2
        
        //  TODO: COLOCAR A LARGURA IGUAL A ALTURA
        ballView.translatesAutoresizingMaskIntoConstraints = false
        ballView.widthAnchor.constraint(equalToConstant: ballRadius).isActive = true
        //                ballView.heigUIExtendedSRGBColorSpacehtAnchor.constraint(equalToConstant: ballRadius).isActive = true
        ballView.heightAnchor.constraint(equalTo: ballView.widthAnchor).isActive = true
        ballView.hsv = self
        return ballView
    }
    
    func getDescriptiveHex() -> String{
        let rgb = RGB(fromHSV: self)
        let r = Int(rgb.red * 255), g = Int(rgb.green * 255), b = Int(rgb.blue * 255)
//        print(rgb.red, rgb.green, rgb.blue)
        print(self.hue, self.saturation, self.value)
        print(r, g, b)
        
//        let rH = (r & 0xFF0000) //>> 4
//        let gH = (g & 0x00FF00) //>> 2
//        let bH = b & 0x0000FF
//        print(rH, gH, bH)
        return (String(format: "%02X%02X%02X", r, g, b))
        
    }
    
    static func == (lhs: HSV, rhs: HSV) -> Bool{
        return lhs.hue == rhs.hue && lhs.saturation == rhs.saturation && lhs.value == rhs.value
    }
}


