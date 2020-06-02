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
    var timer: Timer?
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
        
        let timer = Observable<Int>.interval(DispatchTimeInterval.seconds(10), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return self.vm.requestRate(base: Currency.BTC, quote: Currency.USD)
        }
        
        let rateSubscription = timer.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (rate) in
                print("rate is \(rate.rate)")
            }, onError: { (error) in
                print("error in request rate: \(error)")
            }, onCompleted: {
                print("request rate completed")
            }) {
                print("request disposed")
        }
//        vm.requestRate(base: Currency.BTC, quote: Currency.USD)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (rate) in
//                print("rate is \(rate.rate)")
//            }, onError: { (error) in
//                print("error in request rate: \(error)")
//            }, onCompleted: {
//                print("request rate completed")
//            }) {
//                print("request disposed")
//        }.disposed(by: disposeBag)
    }
}

