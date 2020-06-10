//
//  DepositViewModel.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/8.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class DepositViewModel {
    var toAccount: Account
    var transaction = Transaction()
    var cards: BehaviorRelay<Results<Card>>
    let loading: PublishSubject<Bool> = PublishSubject()
    let selectedCard: BehaviorRelay<Card?> = BehaviorRelay(value: nil)
    
    init(toAcc: Account) {
        toAccount = toAcc
        cards = BehaviorRelay(value: DBManager.sharedInstance.cardRepository.getAll())
    }
    
    func selectCard(at row: Int) {
        selectedCard.accept(cards.value[row])
    }
    
    func deposit(_ amount: Double) {
        loading.onNext(true)
        transaction.type = TransactionType.Deposit
        transaction.inAmount = amount
        transaction.inCurrency = toAccount.currency
        transaction.fromAccount = selectedCard.value!.name
        transaction.toAccount = toAccount.name
        transaction.date = Date()
        
        DBManager.sharedInstance.accountRepository.addTransaction(within: toAccount, transaction: transaction)
        
        loading.onNext(false)
    }
}
