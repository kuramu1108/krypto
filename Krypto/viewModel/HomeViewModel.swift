//
//  HomeViewModel.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewModel {
    public let accounts: Observable<Results<Account>>
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    init() {
        accounts = DBManager.sharedInstance.accountRepository.getAll()
    }
    
    func requestRate(base: Currency, quote: Currency) -> Observable<Rate> {
        return ApiService.getCurrentRate(base: base, quote: quote)
    }
    
    func exchange(from source: Account, to destination: Account, amount: Double, rate: Double) {
        self.loading.onNext(true)
        let outTransaction = Transaction()
        outTransaction.uuid = UUID().uuidString
        outTransaction.type = TransactionType.Exchange
        outTransaction.from = source.name
        outTransaction.to = destination.name
        outTransaction.amount = amount
        outTransaction.rate = rate
        outTransaction.comment = "exchange from \(source.currency.rawValue) to \(destination.currency.rawValue) (1 \(source.currency.rawValue) = \(rate) \(destination.currency.rawValue))"
        
        DBManager.sharedInstance.accountRepository.addTransaction(to: source, transaction: outTransaction)
        DBManager.sharedInstance.accountRepository.addTransaction(to: destination, transaction: outTransaction)
        self.loading.onNext(false)
    }
    
    func transfer(from source: Account, to destination: String, amount: Double) {
        
    }
    
    func deposit(to destination: Account, amount: Double, comment: String) {
        self.loading.onNext(true)
        let transaction = Transaction()
        transaction.uuid = UUID().uuidString
        transaction.type = TransactionType.Deposit
        transaction.to = destination.name
        transaction.amount = amount
        transaction.comment = comment
        
        DBManager.sharedInstance.accountRepository.addTransaction(to: destination, transaction: transaction)
        self.loading.onNext(false)
    }
}
