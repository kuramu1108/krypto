//
//  CardRepository.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/8.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RealmSwift

class CardRepository {
    func getAll() -> Results<Card> {
        let realm = try! Realm()
        return realm.objects(Card.self)
    }
}
