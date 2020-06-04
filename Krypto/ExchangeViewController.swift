//
//  ExchangeViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/2.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExchangeViewController: UIViewController {
    var vm = HomeViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var currencyBuyingTxt: UILabel!
    @IBOutlet weak var amountBuyingTxt: UITextField!
    @IBOutlet weak var rateUpdatingTimeTxt: UILabel!
    @IBOutlet weak var exchangedValueTxt: UILabel!
    @IBOutlet weak var cashBalanceTxt: UILabel!
    
    @IBOutlet weak var baseCurrencyLbl: UILabel!
    @IBOutlet weak var exchangeRateTxt: UILabel!
    @IBOutlet weak var quoteCurrencyLbl: UILabel!
    
    var timer: Timer?
    var updateTimeRemaining = Constants.RateUpdateInterval
    var rateUpdateSubscription: Disposable?
    var currentAccount: Account?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uiSetup()
        setupBindings()
    }
    
    private func setupBindings() {
        vm.requestAccount(currency: Currency.USD)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { result in
                self.cashBalanceTxt.text = "$\(String(result[0].balance)) \(Currency.USD.rawValue)"
            })
            .disposed(by: disposeBag)
        
        vm.requestRate(base: Currency.BTC, quote: Currency.USD)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rate in
                self.exchangeRateTxt.text = String(rate.rate)
            }, onCompleted: {
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.updateTimeRemaining >= 0 {
                        self.updateTimeRemaining -= 1
                        self.rateUpdatingTimeTxt.text = String(self.updateTimeRemaining)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        let repeatTimer = Observable<Int>.interval(DispatchTimeInterval.seconds(10), scheduler: MainScheduler.instance)
            .flatMap { _ in
                return self.vm.requestRate(base: Currency.BTC, quote: Currency.USD)
        }
        
        rateUpdateSubscription = repeatTimer.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (rate) in
                self.timer?.invalidate()
                self.updateTimeRemaining = Constants.RateUpdateInterval
                self.rateUpdatingTimeTxt.text = String(self.updateTimeRemaining)
                self.exchangeRateTxt.text = String(rate.rate)
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.updateTimeRemaining >= 0 {
                        self.updateTimeRemaining -= 1
                        self.rateUpdatingTimeTxt.text = String(self.updateTimeRemaining)
                    }
                }
            }, onError: { (error) in
                print("error in request rate: \(error)")
            }, onCompleted: {
                print("request rate completed")
            }) {
                print("request disposed")
        }
        
        vm.currentAccount
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (account) in
                self.currencyBuyingTxt.text = Currency.BTC.rawValue
                self.baseCurrencyLbl.text = "1 \(account.currency.rawValue ) ="
                self.currentAccount = account
            })
            .disposed(by: disposeBag)
        
        vm.requestCurrentAccount(currency: Currency.USD)
    }
    
    private func uiSetup() {
        quoteCurrencyLbl.text = Currency.USD.rawValue
    }
    
    @IBAction func exchangePressed(_ sender: Any) {
    }
    
    @IBAction func amountChanged(_ sender: Any) {
        guard let intendedAmount = amountBuyingTxt.text else {
            return
        }
        if intendedAmount == "" {
            exchangedValueTxt.text = "$0 \(self.currentAccount?.currency.rawValue ?? "NA")"
        } else {
            let exchangeRate = Double(self.exchangeRateTxt.text!)!
            exchangedValueTxt.text = "$\(Double(intendedAmount)!/exchangeRate) \(self.currentAccount?.currency.rawValue ?? "NA")"
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        rateUpdateSubscription?.disposed(by: disposeBag)
        super.viewWillDisappear(animated)
    }
}
