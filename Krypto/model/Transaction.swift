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
    @objc dynamic var balance = 0.0
    @objc dynamic var currency: String = ""
    @objc dynamic var comment: String = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}

enum TransactionType: Int {
    case Transfer = 1
    case Exchange = 2
}
