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
    @objc private dynamic var privateType: String = TransactionType.Transfer.rawValue
    var type: TransactionType {
        get { return TransactionType(rawValue: privateType)! }
        set { privateType = newValue.rawValue}
    }
    @objc dynamic var date = Date()
    @objc dynamic var fromAccount: String = ""
    @objc dynamic var toAccount: String = ""
    @objc dynamic var outAmount = 0.0
    @objc dynamic var inAmount = 0.0
    @objc private dynamic var privateOutCurrecny = Currency.NA.rawValue
    var outCurrency:Currency {
        get { return Currency(rawValue: privateOutCurrecny)! }
        set { privateOutCurrecny = newValue.rawValue }
    }
    @objc private dynamic var privateInCurrency = Currency.NA.rawValue
    var inCurrency: Currency {
        get {return Currency(rawValue: privateInCurrency)! }
        set { privateInCurrency = newValue.rawValue }
    }
    @objc dynamic var rate: Double = 1.0
    @objc dynamic var comment: String = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

enum TransactionType: String {
    case Transfer = "Transfer"
    case Buy = "Buy"
    case Sell = "Sell"
    case Deposit = "Deposit"
}
