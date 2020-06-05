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
    var accountContacts: [AccountContact]
    
    init() {
        accountContacts = Array(DBManager.sharedInstance.accountContactRepository.getAll())
    }
    
    func transfer(from source: Account, to destination: String, amount: Double, comment: String) {
        let transaction = Transaction()
        transaction.uuid = UUID().uuidString
        transaction.type = TransactionType.Transfer
        transaction.toAccount = destination
        transaction.fromAccount = source.name
        transaction.amount = amount
        transaction.comment = comment
        
        DBManager.sharedInstance.accountRepository.addTransaction(to: source, transaction: transaction)
    }
}
