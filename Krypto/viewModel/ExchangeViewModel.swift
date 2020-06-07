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
    public var baseCurrency: Currency
    public var quoteCurrency: Currency
    public let refreshCounter: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    public let loading: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    public let trading: PublishSubject<Bool> = PublishSubject()
    public let isBuying: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
    init(fromAcc: Account, toAcc: Account) {
        fromAccount = fromAcc
        toAccount = toAcc
        baseCurrency = toAcc.currency
        quoteCurrency = fromAcc.currency
    }
    
    func requestRate() -> Observable<Rate> {
        return ApiService.getCurrentRate(base: baseCurrency, quote: quoteCurrency)
    }
    
    func finishedLoading() {
        if loading.value {
            loading.accept(false)
        }
    }
    
    func refreshIncrement() {
        refreshCounter.accept(refreshCounter.value + 1)
    }
    
    func swapTradingMode() {
        let tempAcc = fromAccount
        fromAccount = toAccount
        toAccount = tempAcc
        isBuying.accept(!isBuying.value)
    }
    
    func exchange(amount: Double, equivalentAmount: Double ,rate: Double) {
        trading.onNext(true)
        let transaction = Transaction()
        if isBuying.value {
            transaction.type = TransactionType.Buy
        } else {
            transaction.type = TransactionType.Sell
        }
        transaction.fromAccount = fromAccount.name
        transaction.toAccount = toAccount.name
        transaction.outAmount = amount
        transaction.inAmount = equivalentAmount
        transaction.rate = rate
        transaction.comment = "(1 \(baseCurrency.rawValue) = \(rate) \(quoteCurrency.rawValue))"
        transaction.currency = Currency.USD
        
        DBManager.sharedInstance.accountRepository.addTransaction(within: fromAccount, transaction: transaction)
        DBManager.sharedInstance.accountRepository.addTransaction(within: toAccount, transaction: transaction)
        trading.onNext(false)
    }
}
