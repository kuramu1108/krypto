//
//  TransferViewModel.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/4.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TransferViewModel {
    var accounts: [Account]
    var accountContacts: [AccountContact]
    var selectedAccount: BehaviorRelay<Account> = BehaviorRelay(value: Account())
    var selectedAccountContact: AccountContact?
    let trading: PublishSubject<Bool> = PublishSubject()
    var transaction = Transaction()
    
    init() {
        accounts = Array(DBManager.sharedInstance.accountRepository.getAll())
        selectedAccount.accept(accounts[0])
        accountContacts = Array(DBManager.sharedInstance.accountContactRepository.getAll())
    }
    
    func transfer(_ amount: Double) {
        trading.onNext(true)
        transaction.type = TransactionType.Transfer
        transaction.toAccount = selectedAccountContact!.ownerName
        transaction.fromAccount = selectedAccount.value.name
        transaction.outAmount = amount
        transaction.outCurrency = selectedAccount.value.currency
        transaction.comment = "Sending to \(selectedAccountContact!.ownerName)"
        
        DBManager.sharedInstance.accountRepository.addTransaction(within: selectedAccount.value, transaction: transaction)
        trading.onNext(false)
    }
    
    func setSelectedAccount(_ row: Int) {
        selectedAccount.accept(accounts[row])
    }
    
    func setSelectedAccountContact(_ row: Int) {
        selectedAccountContact = accountContacts[row]
    }
}
