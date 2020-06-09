//
//  HomeViewModel.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/30.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewModel {
    public let accounts: BehaviorRelay<Results<Account>>
    public let currentAccount: BehaviorRelay<Account>
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    init() {
        let dbrecords = DBManager.sharedInstance.accountRepository.getAll()
        if dbrecords.count == 0 {
            DBManager.sharedInstance.initSampleData()
        }
        accounts = BehaviorRelay.init(value: DBManager.sharedInstance.accountRepository.getAll())
        currentAccount = BehaviorRelay(value: accounts.value[0])
    }
    
    func initSampleData() {
        DBManager.sharedInstance.initSampleData()
        accounts.accept(DBManager.sharedInstance.accountRepository.getAll())
    }
    
    func requestAccountsObservable(currency: Currency) -> Observable<Results<Account>> {
        return DBManager.sharedInstance.accountRepository.getObservableWith(currency: currency)
    }
    
    func requestAccount(currency: Currency) -> Account {
        return DBManager.sharedInstance.accountRepository.getWith(currency: currency)[0]
    }
    
    func switchAccount(to index: Int) {
        currentAccount.accept(accounts.value[index])
    }
}
