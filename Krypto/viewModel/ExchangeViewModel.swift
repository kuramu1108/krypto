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
    public let refreshCounter: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    public let loading: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    
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
    
    func exchange(amount: Double, rate: Double) {
        let outTransaction = Transaction()
        outTransaction.uuid = UUID().uuidString
        outTransaction.type = TransactionType.Exchange
        outTransaction.fromAccount = fromAccount.name
        outTransaction.toAccount = toAccount.name
        outTransaction.amount = amount
        outTransaction.rate = rate
        outTransaction.comment = "exchange from \(fromAccount.currency.rawValue) to \(toAccount.currency.rawValue) (1 \(fromAccount.currency.rawValue) = \(rate) \(toAccount.currency.rawValue))"
        
        DBManager.sharedInstance.accountRepository.addTransaction(to: fromAccount, transaction: outTransaction)
        DBManager.sharedInstance.accountRepository.addTransaction(to: toAccount, transaction: outTransaction)
    }
}
