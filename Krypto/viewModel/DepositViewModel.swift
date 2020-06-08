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
    var mockCards = [Card]()
    var cards: BehaviorRelay<Results<Card>>
    let loading: PublishSubject<Bool> = PublishSubject()
    let selectedCard: BehaviorRelay<Card?> = BehaviorRelay(value: nil)
    
    init(toAcc: Account) {
        toAccount = toAcc
        cards = BehaviorRelay(value: DBManager.sharedInstance.cardRepository.getAll())
        
        let card = Card()
        card.name = "visa"
        let card1 = Card()
        card1.name = "mastercard"
        mockCards.append(card)
        mockCards.append(card1)
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
        
        DBManager.sharedInstance.accountRepository.addTransaction(within: toAccount, transaction: transaction)
        
        loading.onNext(false)
    }
}
