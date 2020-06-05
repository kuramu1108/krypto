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
    public let accounts: BehaviorRelay<Results<Account>>
    public let loading: PublishSubject<Bool> = PublishSubject()
    public let rateUpdater: PublishSubject<Rate> = PublishSubject()
    public var sourceAccount: PublishSubject<Account> = PublishSubject()
//    public let btcRates: PublishSubject<Rate> = PublishSubject()
    public let destinationAccount: PublishSubject<Account> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init() {
        accounts = BehaviorRelay.init(value: DBManager.sharedInstance.accountRepository.getAll())
    }
    
    func initSampleAccounts() {
        DBManager.sharedInstance.accountRepository.createSampleData()
        accounts.accept(DBManager.sharedInstance.accountRepository.getAll())
    }
    
    func requestRate(base: Currency, quote: Currency) -> Observable<Rate> {
        return ApiService.getCurrentRate(base: base, quote: quote)
    }
    
    func requestAccountObservable(currency: Currency) -> Observable<Results<Account>> {
        return DBManager.sharedInstance.accountRepository.getObservableWith(currency: currency)
    }
    
    func requestAccount(currency: Currency) -> Account {
        return DBManager.sharedInstance.accountRepository.getWith(currency: currency)[0]
    }
    
    func requestCurrentAccount(source currencySource: Currency, destination currencyDest: Currency) {
        DBManager.sharedInstance.accountRepository.getObservableWith(currency: currencySource)
            .subscribe(onNext: { [unowned self] (results) in
                self.sourceAccount.onNext(results[0])
            }, onDisposed: {
                print("Home disposed")
            })
        .disposed(by: disposeBag)
        
        DBManager.sharedInstance.accountRepository.getObservableWith(currency: currencyDest)
            .subscribe(onNext: { [unowned self] (results) in
                self.destinationAccount.onNext(results[0])
            }, onDisposed: {
                print("Home disposed")
            })
        .disposed(by: disposeBag)
    }
    
    func exchange(from source: Account, to destination: Account, amount: Double, rate: Double) {
        self.loading.onNext(true)
        let outTransaction = Transaction()
        outTransaction.uuid = UUID().uuidString
        outTransaction.type = TransactionType.Exchange
        outTransaction.fromAccount = source.name
        outTransaction.toAccount = destination.name
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
        transaction.toAccount = destination.name
        transaction.amount = amount
        transaction.comment = comment
        
        DBManager.sharedInstance.accountRepository.addTransaction(to: destination, transaction: transaction)
        self.loading.onNext(false)
    }
}
