//
//  Transaction.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

// use let uuid = UUID().uuidString to generate id
class Transaction: Object {
    @objc dynamic var uuid = ""
    @objc private dynamic var privateType: Int = TransactionType.Transfer.rawValue
    var type: TransactionType {
        get { return TransactionType(rawValue: privateType)! }
        set { privateType = newValue.rawValue}
    }
    @objc dynamic var date = Date()
    @objc dynamic var from: String = ""
    @objc dynamic var to: String = ""
    @objc dynamic var amount = 0.0
    @objc private dynamic var privateCurrecny = Currency.BTC.rawValue
    var currency:Currency {
        get { return Currency(rawValue: privateCurrecny)! }
        set { privateCurrecny = newValue.rawValue }
    }
    @objc dynamic var rate: Double = 1.0
    @objc dynamic var comment: String = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

enum TransactionType: Int {
    case Transfer = 1
    case Exchange = 2
    case Deposit = 3
}
