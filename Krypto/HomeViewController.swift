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
//        let cash = Account()
//        cash.balance = 10000
//        cash.currency = Currency.USD
//        cash.name = "Cash account"
//        
//        let btc = Account()
//        btc.balance = 1.2
//        btc.currency = Currency.BTC
//        btc.name = "Btc account"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue" {
            guard let destinationVC = segue.destination as? ExchangeViewController else {
                return
            }
            let fromAcc = vm.requestAccount(currency: Currency.USD)
            let toAcc = vm.requestAccount(currency: Currency.BTC)
            destinationVC.evm = ExchangeViewModel(fromAcc: fromAcc, toAcc: toAcc)
        }
    }
}

