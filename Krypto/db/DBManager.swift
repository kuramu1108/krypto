//
//  DBManager.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation

class DBManager {
    static let sharedInstance = DBManager()
    var accountRepository: AccountRepository
    var transactionRepository: TransactionRepository
    
    private init() {
        accountRepository = AccountRepository()
        transactionRepository = TransactionRepository()
    }
}
