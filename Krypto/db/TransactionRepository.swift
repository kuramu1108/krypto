//
//  TransactionRepository.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import RealmSwift

class TransactionRepository {
    func create(transaction: Transaction) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(transaction)
        }
    }
}
