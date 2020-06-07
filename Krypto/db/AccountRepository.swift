//
//  AccountRepository.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import RealmSwift
import RxRealm
import RxSwift
import RxCocoa

class AccountRepository {
    func createOrUpdate(account: Account) {
        let realm = try! Realm()
        if account.uuid == "" {
            account.uuid = UUID().uuidString
        }
        try! realm.write {
            realm.add(account, update: .modified)
        }
    }
    
    func getAll() -> Results<Account> {
        let realm = try! Realm()
        return realm.objects(Account.self)
    }
    
    func getWith(currency: Currency) -> Results<Account> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "privateCurrency = %@", currency.rawValue)
        return realm.objects(Account.self).filter(predicate)
    }
    
    func getObservableWith(currency: Currency) -> Observable<Results<Account>> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "privateCurrency = %@", currency.rawValue)
        return Observable.collection(from: realm.objects(Account.self).filter(predicate))
    }
    
    func addTransaction(within account: Account, transaction: Transaction) {
        if transaction.uuid == "" {
            transaction.uuid = UUID().uuidString
        }
        let realm = try! Realm()
        try! realm.write {
            account.transactions.append(transaction)
            if transaction.fromAccount == account.name {
                // outgoing transaction
                account.balance -= transaction.outAmount
            } else {
                // incoming transaction
                account.balance += transaction.inAmount
            }
        }
    }
}
