//
//  HarmonyProvider.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation


class Palette{
    internal init(name: String?, colors: [HSV]?, createdAt: Date?) {
        self.name = name
        self.colors = colors
        self.createdAt = createdAt
    }
    
    
    
    var name: String!
    var colors: [HSV]!
    var createdAt: Date!
    
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
        let palette = Palette(name: "#\(self.palettes.count + 1)", colors: colors.map({ (h) -> HSV in
            return h
        }), createdAt: Date())
        self.palettes.append(palette)
        self.palettes = self.palettes.sorted(by: { (p1, p2) -> Bool in
            return p1.createdAt < p2.createdAt
        })
    }
    
    func getPallete(at index: IndexPath) -> Palette{
        return self.palettes[index.item]
    }
    
    func getColor(at index: IndexPath) -> HSV {
        return self.colors[index.item]
    }
    
    func getPaletteCount() -> Int{
        return self.palettes.count
    }
    
    func getColorCount() -> Int{
        return self.colors.count
    }
    
    func getPalettes() -> [Palette]{
        return self.palettes.sorted(by: { (p1, p2) -> Bool in
            return p1.createdAt < p2.createdAt
        })
//        
//        return [
//            Palette(name: "teste", colors: [
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1)
//                ]),
//            Palette(name: "#2", colors: [
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1)
//                ]),
//            
//            Palette(name: "teste", colors: [
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1)
//                ]),
//            Palette(name: "#2", colors: [
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1)
//                ]),
//            
//            Palette(name: "teste", colors: [
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1)
//                ]),
//            Palette(name: "#2", colors: [
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1)
//                ]),
//            
//            Palette(name: "teste", colors: [
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1)
//                ]),
//            Palette(name: "#2", colors: [
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1)
//                ]),
//            
//            Palette(name: "teste", colors: [
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 90, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1)
//                ]),
//            Palette(name: "#2", colors: [
//                HSV(hue: 120, saturation: 1, value: 1),
//                HSV(hue: 170, saturation: 1, value: 1),
//                HSV(hue: 230, saturation: 1, value: 1),
//                HSV(hue: 30, saturation: 1, value: 1),
//                HSV(hue: 60, saturation: 1, value: 1)
//                ])
//        ]
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
