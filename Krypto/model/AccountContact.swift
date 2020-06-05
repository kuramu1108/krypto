//
//  AccountContacts.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/4.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

class AccountContact: Object {
    @objc dynamic var uuid = ""
    @objc dynamic var ownerName = ""
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
