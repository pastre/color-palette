//
//  StoreObserver.swift
//  Color Palette
//
//  Created by Bruno Pastre on 22/09/19.
//  Copyright © 2019 Bruno Pastre. All rights reserved.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver{
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Updated payment queue", queue, transactions)
    }
    
}
