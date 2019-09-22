//
//  BallLongPressGestureRecognizer.swift
//  Color Palette
//
//  Created by Bruno Pastre on 05/07/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import UIKit

class BallLongPressGestureRecognizer: UILongPressGestureRecognizer {

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        print("Moveu!!", event)
    }
    
}
