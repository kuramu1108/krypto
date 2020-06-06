//
//  DBManager.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation

class DBManager {
    static let sharedInstance = DBManager()
    var accountRepository: AccountRepository
    var transactionRepository: TransactionRepository
    var accountContactRepository: AccountContactRepository
    
    private init() {
        accountRepository = AccountRepository()
        transactionRepository = TransactionRepository()
        accountContactRepository = AccountContactRepository()
    }
    
    func initSampleData() {
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
        
        accountRepository.createOrUpdate(account: cash)
        accountRepository.createOrUpdate(account: btc)
        accountRepository.createOrUpdate(account: eth)
        accountRepository.createOrUpdate(account: xrp)
        
        let contacts = ["Bill", "Michael", "Chris", "Ray", "Darren", "Rosewater", "Jimmy", "Josh", "Lili", "Shan"]
        contacts.forEach { (ownerName) in
            let accountContact = AccountContact()
            accountContact.ownerName = ownerName
            accountContactRepository.create(contact: accountContact)
        }
    }
}
