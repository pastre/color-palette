//
//  ColorActivityItemProvider.swift
//  Color Palette
//
//  Created by Bruno Pastre on 09/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class ColorActivityItemProvider: UIActivityItemProvider{
    
    var color: HSV!
    
    override var item: Any{
        if self.activityType == .copyToPasteboard{
            return "\(color.getDescriptiveHex())"
        }
        return """
        Try out this color I discovered in Easy Color Picker
            #\(color.getDescriptiveHex())
        Harmonify is avaiable in the App Store
        Download it now https://apps.apple.com/us/app/easy-color-picker/id1467642991?l=pt&ls=1
        """
    }
}

