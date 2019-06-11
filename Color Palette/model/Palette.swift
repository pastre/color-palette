//
//  Palette.swift
//  Color Palette
//
//  Created by Bruno Pastre on 06/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

class Palette: NSObject, NSCoding, Serializable{
    
    var name: String!
    var colors: [HSV]!
    var createdAt: Date!
    
    required init?(coder aDecoder: NSCoder) {
        self.name = (aDecoder.decodeObject(forKey: "name") as! String)
        self.createdAt = (aDecoder.decodeObject(forKey: "createdAt") as! Date)
        self.colors = (aDecoder.decodeObject(forKey: "colors") as! [HSV])
    }
    
    internal init(name: String?, colors: [HSV]?, createdAt: Date?) {
        self.name = name
        self.colors = colors
        self.createdAt = createdAt
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.createdAt, forKey: "createdAt")
        aCoder.encode(self.colors, forKey: "colors")
    }
    
}
