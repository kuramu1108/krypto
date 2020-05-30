//
//  Account.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Account: Object {
    @objc dynamic var uuid = ""
    @objc dynamic var name = ""
    @objc private dynamic var privateCurrecny = Currency.BTC.rawValue
    var currency:Currency {
        get { return Currency(rawValue: privateCurrecny)! }
        set { privateCurrecny = newValue.rawValue }
    }
    @objc dynamic var balance: Double = 0.0
    let transactions = List<Transaction>()
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

enum Currency: Int {
    case BTC = 1
    case ETH = 2
    case XRP = 3
    case AUD = 4
    case USD = 5
}
