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

enum Currency: String {
    case BTC = "BTC"
    case ETH = "ETH"
    case XRP = "XRP"
    case AUD = "AUD"
    case USD = "USD"
}
