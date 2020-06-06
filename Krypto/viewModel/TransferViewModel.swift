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
    
    init() {
        accounts = Array(DBManager.sharedInstance.accountRepository.getAll())
        selectedAccount.accept(accounts[0])
        accountContacts = Array(DBManager.sharedInstance.accountContactRepository.getAll())
    }
    
    func transfer(_ amount: Double) {
        trading.onNext(true)
        let transaction = Transaction()
        transaction.type = TransactionType.Transfer
        transaction.toAccount = selectedAccountContact!.ownerName
        transaction.fromAccount = selectedAccount.value.name
        transaction.amount = amount
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
