//
//  FirstViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/29.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewController: UIViewController {
    var timer: Timer?
    var vm = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "can not obtain default config url")
        // Do any additional setup after loading the view.
        setupBindings()
    }
    
    private func setupBindings() {
//        let account = Account()
//        account.name = "Cash Account"
//        account.currency = Currency.USD
//        account.balance = 10000.0
//        DBManager.sharedInstance.accountRepository.createOrUpdate(account: account)
    }
}

