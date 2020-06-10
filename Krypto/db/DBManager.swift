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
    var cardRepository: CardRepository
    var userRepository: UserRepository
    
    private init() {
        accountRepository = AccountRepository()
        transactionRepository = TransactionRepository()
        accountContactRepository = AccountContactRepository()
        cardRepository = CardRepository()
        userRepository = UserRepository()
    }
    
    func initSampleData() {
        let cash = Account()
        cash.balance = 0.0
        cash.currency = Currency.USD
        cash.name = "Cash Account"
        let btc = Account()
        btc.balance = 0.0
        btc.currency = Currency.BTC
        btc.name = "BTC Account"
        let eth = Account()
        eth.balance = 0.0
        eth.currency = Currency.ETH
        eth.name = "ETH Account"
        let xrp = Account()
        xrp.balance = 0.0
        xrp.currency = Currency.XRP
        xrp.name = "XRP Account"
        
        accountRepository.createOrUpdate(account: cash)
        accountRepository.createOrUpdate(account: btc)
        accountRepository.createOrUpdate(account: eth)
        accountRepository.createOrUpdate(account: xrp)
        
        let transaction1 = Transaction()
        transaction1.type = TransactionType.Deposit
        transaction1.toAccount = cash.name
        transaction1.inAmount = 10000
        transaction1.comment = "init deopsit"
        transaction1.inCurrency = Currency.USD
        accountRepository.addTransaction(within: cash, transaction: transaction1)
        
        let transaction2 = Transaction()
        transaction2.type = TransactionType.Deposit
        transaction2.toAccount = btc.name
        transaction2.inAmount = 1.234
        transaction2.comment = "init deopsit"
        transaction2.inCurrency = Currency.BTC
        accountRepository.addTransaction(within: btc, transaction: transaction2)
        
        let transaction3 = Transaction()
        transaction3.type = TransactionType.Deposit
        transaction3.toAccount = eth.name
        transaction3.inAmount = 145
        transaction3.comment = "init deopsit"
        transaction3.inCurrency = Currency.ETH
        accountRepository.addTransaction(within: eth, transaction: transaction3)
        
        let transaction4 = Transaction()
        transaction4.type = TransactionType.Deposit
        transaction4.toAccount = xrp.name
        transaction4.inAmount = 754
        transaction4.comment = "init deopsit"
        transaction4.inCurrency = Currency.XRP
        accountRepository.addTransaction(within: xrp, transaction: transaction4)
        
        let contacts = ["Bill", "Michael", "Chris", "Ray", "Darren", "Rosewater", "Jimmy", "Josh", "Lili", "Shan"]
        contacts.forEach { (ownerName) in
            let accountContact = AccountContact()
            accountContact.ownerName = ownerName
            accountContactRepository.create(contact: accountContact)
        }
    }
}
