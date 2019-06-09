//
//  PaletteActivityItemProvider.swift
//  Color Palette
//
//  Created by Bruno Pastre on 08/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class PaletteActivityItemProvider: UIActivityItemProvider{
    
    //    init(item: String){
    //        super.init(placeholderItem: item)
    //    }
    //
    var palette =  HarmonyProvider.instance.palettes.first!
    func getSketchPalette() -> URL?{
        var url = URL(fileURLWithPath: NSTemporaryDirectory())
        url.appendPathComponent(self.palette.name)
        url.appendPathExtension("sketchpalette")
        
        guard let string = SketchConverter(palette: self.palette).getJson() else { return nil }
        do {
            try string.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch let error {
            print("Error writing to file", error.localizedDescription)
        }
        return nil
    }
    
    func getPaletteDescription() -> String{
        var ret = ""
        for color in self.palette.colors{
            let rgb = RGB(fromHSV: color)
            let hex = color.getDescriptiveHex()
            let toAppend = """
            #\(hex):
            Red: \(rgb.red),
            Green: \(rgb.green),
            Blue: \(rgb.blue),
            
            """
            ret += toAppend
        }
        return ret
    }
    
    override var item: Any{
        switch self.activityType!
        {
        case .airDrop:
            if let url = self.getSketchPalette(){
                return url
            }
        default: break
        }
        
        return """
        Check out this palette I created using Harmonify:
        \(self.getPaletteDescription())
        Harmonify is avaiable at App Store
        Download now <COLOCAR A URL AQUI>
        """
    }
    
}
