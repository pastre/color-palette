//
//  HarmonyProvider.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class HarmonyProvider{
    
    static let instance = HarmonyProvider()
    
    var palettesFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("palettes").path)
    }
    var colorsFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("colors").path)
    }
    
    var palettes: [Palette]! {
        willSet(to){
            self.persistPalette()
        }
        didSet{
            self.persistPalette()
        }
    }
    var colors: [HSV]!{
        didSet{
            NSKeyedArchiver.archiveRootObject(colors!, toFile: self.colorsFilePath)
        }
    }
    
    private init(){
        self.palettes = NSKeyedUnarchiver.unarchiveObject(withFile: self.palettesFilePath) as? [Palette] ?? [Palette]()
        self.colors = NSKeyedUnarchiver.unarchiveObject(withFile: self.colorsFilePath) as? [HSV] ?? [HSV]()
    }
    
    func addPalette(colors: [HSV]){
        let palette = Palette(name: "#\(self.palettes.count + 1)", colors: colors.map({ (h) -> HSV in
            return h
        }), createdAt: Date())
        self.palettes.append(palette)
        self.palettes = self.palettes.sorted(by: { (p1, p2) -> Bool in
            return p1.createdAt > p2.createdAt
        })
        self.persistPalette()
    }
    
    func updatePalette(palette: Palette, name: UITextField){
        let index = self.getIndex(for: palette)!
        if name.hasText{
            self.palettes[index].name = name.text
        } else {
            self.palettes[index].name = "#\(index + 1)"
        }
        self.persistPalette()
    }
    
    func containsColor(_ color: HSV) -> Bool{
        return  self.colors.contains(where: { (h) -> Bool in
            h == color
        })
    }
    
    func updateColors(with color: HSV){
        
        if self.containsColor(color){
            for (i, j) in self.colors.enumerated(){
                if j == color{
                    self.colors.remove(at: i)
                    break
                }
            }
        } else {
            self.colors.append(color)
        }
        self.persistPalette()
    }
    
    func persistPalette(){
        
        NSKeyedArchiver.archiveRootObject(palettes!, toFile: self.palettesFilePath)
        
        do {
            let p = try JSONEncoder().encode(palettes)
            let b64 = p.base64EncodedData()
            NSUbiquitousKeyValueStore.default.set(b64, forKey: "palettes")
            if NSUbiquitousKeyValueStore.default.synchronize() {
                print("SYNCD NA NUVEM!!!!")
            }
            print("Mudei  na fucking nuvem", b64)
        } catch let error {
            print("Deu ruim pra encodar", error.localizedDescription)
        }
    }
    
    // MARK: - Getters
    
    func getPalette(at index: IndexPath) -> Palette{
        return self.palettes[index.item]
    }
    
    func getIndex(for palette: Palette) -> Int? {
        return self.palettes.firstIndex(of: palette)
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
        return self.palettes
//            .sorted(by: { (p1, p2) -> Bool in
//            return p1.createdAt < p2.createdAt
//        })
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
