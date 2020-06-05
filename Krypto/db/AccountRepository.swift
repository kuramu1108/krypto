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
    
    func addTransaction(to account: Account, transaction: Transaction) {
        let realm = try! Realm()
        try! realm.write {
            account.transactions.append(transaction)
            if transaction.fromAccount == account.name {
                account.balance -= transaction.amount
            } else {
                account.balance += transaction.amount
            }
        }
    }
    
    func createSampleData() {
        let cash = Account()
        cash.balance = 10000
        cash.currency = Currency.USD
        cash.name = "Cash Account"
        let btc = Account()
        btc.balance = 1.2
        btc.currency = Currency.BTC
        btc.name = "BTC Account"
        let eth = Account()
        eth.balance = 203.2
        eth.currency = Currency.ETH
        eth.name = "ETH Account"
        let xrp = Account()
        xrp.balance = 502.31
        xrp.currency = Currency.XRP
        xrp.name = "XRP Account"
        
        createOrUpdate(account: cash)
        createOrUpdate(account: btc)
        createOrUpdate(account: eth)
        createOrUpdate(account: xrp)
    }
}
