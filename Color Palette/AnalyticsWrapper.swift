//
//  AnalyticsWrapper.swift
//  Color Palette
//
//  Created by Bruno Pastre on 16/01/20.
//  Copyright © 2020 Bruno Pastre. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class AnalyticsWrapper {
    
    static let instance = AnalyticsWrapper()
   
    
    func onPaletteSaved(_ palette: [HSV]) {
        let colorHex = palette.map { (color) -> String in
            return color.getDescriptiveHex()
        }
        
        Analytics.logEvent("palette_created", parameters: ["colors": colorHex])
        
    }
    
    func onColorShared(_ color: HSV) {
        Analytics.logEvent("color_created", parameters: ["color": color.getDescriptiveHex()])
    }
    
    func onColorDeleted(_ color: HSV) {
        
        Analytics.logEvent("color_deleted", parameters: nil)
    }
    
    func onPaletteDeleted() {
        Analytics.logEvent("palette_deleted", parameters: nil)
    }
    
    func onPaletteShared() {
       
        Analytics.logEvent("palette_shared", parameters: nil)
    }
    
}
