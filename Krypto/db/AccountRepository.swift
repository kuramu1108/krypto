//
//  AccountRepository.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import RealmSwift

class AccountRepository {
    func createOrUpdate(account: Account) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(account, update: .modified)
        }
    }
    
    func getAll() -> Results<Account> {
        let realm = try! Realm()
        return realm.objects(Account.self)
    }
    
    func addTransaction(to account: Account, transaction: Transaction) {
        let realm = try! Realm()
        try! realm.write {
            account.transactions.append(transaction)
        }
    }
}
