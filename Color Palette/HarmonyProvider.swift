//
//  HarmonyProvider.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation


class Palette{
    internal init(name: String?, colors: [HSV]?) {
        self.name = name
        self.colors = colors
    }
    
    var name: String!
    var colors: [HSV]!
    
}


class HarmonyProvider{
    
    static let instance = HarmonyProvider()
    
    var palettes: [Palette]!
    var colors: [HSV]!
    
    private init(){
        self.palettes = [Palette]()
        self.colors = [HSV]()
    }
    
    func addPalette(colors: [HSV]){
        let palette = Palette(name: "#\(self.palettes.count)", colors: colors)
        self.palettes.append(palette)
    }
    
    func getPalettes() -> [Palette]{
        return [
            Palette(name: "teste", colors: [
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1)
                ]),
            Palette(name: "#2", colors: [
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1)
                ]),
            
            Palette(name: "teste", colors: [
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1)
                ]),
            Palette(name: "#2", colors: [
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1)
                ]),
            
            Palette(name: "teste", colors: [
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1)
                ]),
            Palette(name: "#2", colors: [
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1)
                ]),
            
            Palette(name: "teste", colors: [
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1)
                ]),
            Palette(name: "#2", colors: [
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1)
                ]),
            
            Palette(name: "teste", colors: [
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 90, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1)
                ]),
            Palette(name: "#2", colors: [
                HSV(hue: 120, saturation: 1, value: 1),
                HSV(hue: 170, saturation: 1, value: 1),
                HSV(hue: 230, saturation: 1, value: 1),
                HSV(hue: 30, saturation: 1, value: 1),
                HSV(hue: 60, saturation: 1, value: 1)
                ])
        ]
    }
    
    func getColors() -> [HSV]{
        return [
            HSV(hue: 30, saturation: 1, value: 1),
            HSV(hue: 60, saturation: 1, value: 1),
            HSV(hue: 90, saturation: 1, value: 1),
            HSV(hue: 120, saturation: 1, value: 1),
            HSV(hue: 170, saturation: 1, value: 1),
            HSV(hue: 230, saturation: 1, value: 1),
            ]
    }
}
