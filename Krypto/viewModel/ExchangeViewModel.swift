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
    public var fromAccount: BehaviorRelay<Account>
    public var toAccount: BehaviorRelay<Account>
    public let refreshCounter: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    
    init(fromAcc: Account, toAcc: Account) {
        fromAccount = BehaviorRelay(value: fromAcc)
        toAccount = BehaviorRelay(value: toAcc)
    }
    
    func exchange(amount: Double, rate: Double) {
        let outTransaction = Transaction()
        outTransaction.uuid = UUID().uuidString
        outTransaction.type = TransactionType.Exchange
        outTransaction.fromAccount = fromAccount.value.name
        outTransaction.toAccount = toAccount.value.name
        outTransaction.amount = amount
        outTransaction.rate = rate
        outTransaction.comment = "exchange from \(fromAccount.value.currency.rawValue) to \(toAccount.value.currency.rawValue) (1 \(fromAccount.value.currency.rawValue) = \(rate) \(toAccount.value.currency.rawValue))"
        
        DBManager.sharedInstance.accountRepository.addTransaction(to: fromAccount.value, transaction: outTransaction)
        DBManager.sharedInstance.accountRepository.addTransaction(to: toAccount.value, transaction: outTransaction)
    }
}
