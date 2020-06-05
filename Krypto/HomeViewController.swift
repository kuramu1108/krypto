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
        vm.accounts
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] results in
                if results.count == 0 {
                    self.vm.initSampleAccounts()
                }
            })
            .disposed(by: disposeBag)
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
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        
    }
}

