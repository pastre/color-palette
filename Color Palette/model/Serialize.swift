//
//  Serialize.swift
//  Color Palette
//
//  Created by Bruno Pastre on 11/06/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation

protocol Serializable: Codable {
    func serialize() -> Data?
//    func deserialize(from data: Data?) -> Self?
}

extension Serializable{
    func toBase64() -> String?{
        return self.serialize()!.base64EncodedString()
    }
}

extension Serializable{
    func serialize() -> Data?{
        return try? JSONEncoder().encode(self)
    }
    
    static func deserialize(from data: Data?) -> Self?{
//        let json = String(from: data, encoding: .utf8)
        return try? JSONDecoder().decode(Self.self, from: data!)
    }
}

