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
    
    func initSampleData() {
        DBManager.sharedInstance.initSampleData()
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
        
        DBManager.sharedInstance.accountRepository.addTransaction(within: destination, transaction: transaction)
        self.loading.onNext(false)
    }
}
