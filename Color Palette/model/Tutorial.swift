//
//  Tutorial.swift
//  Color Palette
//
//  Created by Bruno Pastre on 02/07/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit
class Tutorial: NSObject, NSCoding{
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hasOpenedOverlay, forKey: "hasOpenedOverlay")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.hasOpenedOverlay = aDecoder.decodeObject(forKey: "hasOpenedOverlay") as? Bool ?? false
    }
    
    var hasOpenedOverlay: Bool!
    var isAnimating: Bool!
    
    override init(){
        
        super.init()
        self.hasOpenedOverlay = false
        self.isAnimating = false
    }
    
}

class TutorialController{
    
    static let instance = TutorialController()
    
    var tutorialFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("tutorial").path)
    }
    var tutorial: Tutorial!
    
    private init(){
        self.tutorial = NSKeyedUnarchiver.unarchiveObject(withFile: self.tutorialFilePath) as? Tutorial ?? Tutorial()
    }
    
    func hasOpenedOverlay() -> Bool{
        return self.tutorial.hasOpenedOverlay
    }
    
    func onOverlayOpened(){
        self.tutorial.hasOpenedOverlay = true
        self.persistTutorial()
    }
    
    func persistTutorial(){
        NSKeyedArchiver.archiveRootObject(self.tutorial, toFile: self.tutorialFilePath)
    }
}
