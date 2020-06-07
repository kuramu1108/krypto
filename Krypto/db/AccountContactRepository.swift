//
//  AccountContactRepository.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/4.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import RealmSwift

class AccountContactRepository {
    func getAll() -> Results<AccountContact> {
        let realm = try! Realm()
        return realm.objects(AccountContact.self)
    }
    
    func create(contact: AccountContact) {
        contact.uuid = UUID().uuidString
        let realm = try! Realm()
        try! realm.write {
            realm.add(contact)
        }
    }
}
