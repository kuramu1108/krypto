//
//  User.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
}
