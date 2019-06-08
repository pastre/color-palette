//
//  Sketch.swift
//  Color Palette
//
//  Created by Bruno Pastre on 08/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class SketchConverter{
    
    var palette: Palette!
    
    init(palette: Palette) {
        self.palette = palette
    }
    
    func getFormattedColors() -> [[String: Any]]{
        var ret = [[String: Any]]()
        for color in self.palette.colors{
            let rgb = RGB(fromHSV: color)
            let toAppend = [
                "red": rgb.red,
                "green": rgb.green,
                "blue": rgb.blue,
                "alpha": 1
            ]
            ret.append(toAppend)
        }
        
        return ret
    }
    
    func getJson() -> String?{
        let colors = self.getFormattedColors()
        let dict: [String: Any] = [
            "compatibleVersion":"1.4",
            "pluginVersion":"1.5",
            "colors": colors
        ]
        do {
            let jsonString = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            return String(data: jsonString, encoding: .utf8)
        } catch let error {
            print("Erro no json", error.localizedDescription)
        }
        return nil
    }
}
