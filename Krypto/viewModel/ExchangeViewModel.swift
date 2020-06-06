//
//  ExchangeViewModel.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/4.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ExchangeViewModel {
    public var fromAccount: Account
    public var toAccount: Account
    public let refreshCounter: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public let loading: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    public let trading: PublishSubject<Bool> = PublishSubject()
    init(fromAcc: Account, toAcc: Account) {
        fromAccount = fromAcc
        toAccount = toAcc
    }
    
    func requestRate(base: Currency, quote: Currency) -> Observable<Rate> {
        return ApiService.getCurrentRate(base: base, quote: quote)
    }
    
    func finishedLoading() {
        if loading.value {
            loading.accept(false)
        }
    }
    
    func refreshIncrement() {
        refreshCounter.accept(refreshCounter.value + 1)
    }
    
    func exchange(amount: Double, rate: Double) {
        trading.onNext(true)
        let outTransaction = Transaction()
        outTransaction.type = TransactionType.Exchange
        outTransaction.fromAccount = fromAccount.name
        outTransaction.toAccount = toAccount.name
        outTransaction.amount = amount
        outTransaction.rate = rate
        outTransaction.comment = "(1 \(toAccount.currency.rawValue) = \(rate) \(fromAccount.currency.rawValue))"
        outTransaction.currency = Currency.USD
        
        DBManager.sharedInstance.accountRepository.addTransaction(within: fromAccount, transaction: outTransaction)
        DBManager.sharedInstance.accountRepository.addTransaction(within: toAccount, transaction: outTransaction)
        trading.onNext(false)
    }
}
