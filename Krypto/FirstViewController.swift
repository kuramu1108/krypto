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

class FirstViewController: UIViewController {
    var vm = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupBindings()
    }
    
    private func setupBindings() {
        vm.accounts
            .observeOn(MainScheduler.instance)
            .subscribe { event in
                print(event)
            }
            .disposed(by: disposeBag)
    }

}

