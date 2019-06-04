////
////  Structs.swift
////  Color Palette
////
////  Created by Bruno Pastre on 03/06/19.
////  Copyright © 2019 Bruno Pastre. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//struct RGBBak {
//    // Percent
//    let r: CGFloat // [0,1]
//    let g: CGFloat // [0,1]
//    let b: CGFloat // [0,1]
//    
//    static func hsv(r: Float, g: Float, b: Float) -> HSV {
//        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
//        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
//        
//        let v = max
//        let delta = max - min
//        
//        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: CGFloat(max)) }
//        guard max > 0 else { return HSV(h: -1, s: 0, v: CGFloat(v)) } // Undefined, achromatic grey
//        let s = delta / max
//        
//        let hue: (Float, Float) -> Float = { max, delta -> Float in
//            if r == max { return (g-b)/delta } // between yellow & magenta
//            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
//            else { return 4 + (r-g)/delta } // between magenta & cyan
//        }
//        
//        let h = hue(max, delta) * 60 // In degrees
//        
//        return HSV(h: (h < 0 ? CGFloat(h+360) : CGFloat(h)) , s: CGFloat(s), v: CGFloat(v))
//    }
//    
//    static func hsv(rgb: RGB) -> HSV {
//        return hsv(r: Float(rgb.r), g: Float(rgb.g), b: Float(rgb.b))
//    }
//    
//    var hsv: HSV {
//        return RGB.hsv(rgb: self)
//    }
//}
//
//struct RGBABak {
//    let a: CGFloat
//    let rgb: RGB
//    
//    init(r: Float, g: Float, b: Float, a: Float) {
//        self.a = CGFloat(a)
//        self.rgb = RGB(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
//    }
//}
//
//struct HSVBAK {
//    let h: CGFloat // Angle in degrees [0,360] or -1 as Undefined
//    let s: CGFloat // Percent [0,1]
//    let v: CGFloat // Percent [0,1]
//    
//    static func rgb(h: Float, s: Float, v: Float) -> RGB {
//        if s == 0 { return RGB(r: CGFloat(v), g: CGFloat(v), b: CGFloat(v)) } // Achromatic grey
//        
//        let angle = (h >= 360 ? 0 : h)
//        let sector = angle / 60 // Sector
//        let i = floor(sector)
//        let f = sector - i // Factorial part of h
//        
//        let p = v * (1 - s)
//        let q = v * (1 - (s * f))
//        let t = v * (1 - (s * (1 - f)))
//        
//        switch(i) {
//        case 0:
//            return RGB(r: CGFloat(v), g: CGFloat(t), b: CGFloat(p))
//        case 1:
//            return RGB(r: CGFloat(q), g: CGFloat(v), b: CGFloat(p))
//        case 2:
//            return RGB(r: CGFloat(p), g: CGFloat(v), b: CGFloat(t))
//        case 3:
//            return RGB(r: CGFloat(p), g: CGFloat(q), b: CGFloat(v))
//        case 4:
//            return RGB(r: CGFloat(t), g: CGFloat(p), b: CGFloat(v))
//        default:
//            return RGB(r: CGFloat(v), g: CGFloat(p), b: CGFloat(q))
//        }
//    }
//    
//    static func rgb(hsv: HSV) -> RGB {
//        return rgb(h: Float(hsv.h), s: Float(hsv.s), v: Float(hsv.v))
//    }
//    
//    static func copy(from toCopy: HSV) -> HSV{
//        return HSV(h: toCopy.h, s: toCopy.s, v: toCopy.v)
//    }
//    
//    static func uiColor(from hsv: HSV) -> UIColor{
//        return UIColor(hue: hsv.h, saturation: hsv.s, brightness: hsv.v, alpha: 1)
//    }
//    
//    var rgb: RGB {
//        return HSV.rgb(hsv: self)
//    }
//    
//    var complementary: HSV{
//        return HSV(h: (h + 180 > 360 ? (h + 180).truncatingRemainder(dividingBy: 360) : h + 180), s: s, v: v)
//    }
//    
//    var uicolor: UIColor{
//        return UIColor(hue: h, saturation: s, brightness: v, alpha: 1)
//    }
//    
//    /// Returns a normalized point with x=h and y=v
//    var point: CGPoint {
//        return CGPoint(x: CGFloat(h/360), y: CGFloat(v))
//    }
//}
