//
//  Card.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/8.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

class Card: Object {
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var cardNumber: String = ""
    @objc dynamic var holderName: String = ""
    @objc dynamic var expiryDate: String = ""
    @objc dynamic var cvv: String = ""
    
    override class func primaryKey() -> String? {
        return "uuid"
    }
}
