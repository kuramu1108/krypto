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
import SwiftSpinner

class ExchangeViewController: UIViewController {
//    var vm = HomeViewModel()
    var evm: ExchangeViewModel!
    let disposeBag = DisposeBag()

    @IBOutlet weak var currencyBuyingTxt: UILabel!
    @IBOutlet weak var amountBuyingTxt: UITextField!
    @IBOutlet weak var rateUpdatingTimeTxt: UILabel!
    
    @IBOutlet weak var exchangedValueLbl: UILabel!
    @IBOutlet weak var toCurrencyLbl: UILabel!
    
    @IBOutlet weak var cashBalanceTxt: UILabel!
    
    @IBOutlet weak var baseCurrencyLbl: UILabel!
    @IBOutlet weak var exchangeRateTxt: UILabel!
    @IBOutlet weak var quoteCurrencyLbl: UILabel!
        
    var timer: Timer?
    var updateTimeRemaining = Constants.RateUpdateInterval
    var timerSubsciption: Disposable?
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uiSetup()
        setupBindings()
    }
    
    private func setupBindings() {
        evm.loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (shouldShow) in
                if shouldShow {
                    SwiftSpinner.show("Loading")
                } else {
                    SwiftSpinner.hide()
                }
            })
            .disposed(by: disposeBag)
        let repeatTimer = Observable<Int>
            .timer(.seconds(0), period: .seconds(Constants.RateUpdateInterval), scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ in
                return self.evm.requestRate(base: self.evm.toAccount.currency, quote: self.evm.fromAccount.currency)
        }
        
        timerSubsciption = repeatTimer.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (rate) in
                print("requested")
                self.timer?.invalidate()
                self.updateTimeRemaining = Constants.RateUpdateInterval
                self.rateUpdatingTimeTxt.text = String(self.updateTimeRemaining)
                self.exchangeRateTxt.text = String(rate.rate)
                self.updateExchangedValue()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if self.updateTimeRemaining > 0 {
                        self.updateTimeRemaining -= 1
                        self.rateUpdatingTimeTxt.text = String(self.updateTimeRemaining)
                    }
                }
                self.evm.finishedLoading()
            }, onError: { (error) in
                print("error in request rate: \(error)")
            }, onCompleted: {
                print("request rate completed")
            }, onDisposed:  {
                print("request disposed")
            })
        
        evm.trading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] trading in
                if trading {
                    SwiftSpinner.show("Making Transaction")
                } else {
                    SwiftSpinner.hide()
                    self.performSegue(withIdentifier: "segueToExchangeComplete", sender: self)
                }
            })
            .disposed(by: disposeBag)
        
        // exchange view model implementation
        cashBalanceTxt.text = "$\(String(evm.fromAccount.balance)) \(evm.fromAccount.currency.rawValue)"
        baseCurrencyLbl.text = "1 \(evm.toAccount.currency.rawValue ) ="
        
        currencyBuyingTxt.text = evm.toAccount.currency.rawValue
        toCurrencyLbl.text = evm.toAccount.currency.rawValue
        
        // home view model implementation
//        vm.sourceAccount
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] (account) in
//                self.cashBalanceTxt.text = "$\(String(account.balance)) \(account.currency.rawValue)"
//                self.baseCurrencyLbl.text = "1 \(account.currency.rawValue ) ="
//            })
//            .disposed(by: disposeBag)
//
//        vm.destinationAccount
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [unowned self] account in
//                self.currencyBuyingTxt.text = account.currency.rawValue
//                self.exchangedCurrency.text = account.currency.rawValue
//            }, onDisposed: {
//                print("account disposed")
//            })
//            .disposed(by: disposeBag)
//
//        vm.requestCurrentAccount(source: Currency.USD, destination: Currency.BTC)
    }
    
    private func uiSetup() {
        quoteCurrencyLbl.text = Currency.USD.rawValue
    }
    
    @IBAction func exchangePressed(_ sender: Any) {
        guard let intendedAmount = Double(amountBuyingTxt.text!) else {
            return
        }
        guard intendedAmount <= evm.fromAccount.balance else {
            // add alert
            print("not enough found")
            return
        }
        let exchangeRate = Double(exchangeRateTxt.text!)!
        evm.exchange(amount: intendedAmount, rate: exchangeRate)
    }
    
    @IBAction func amountChanged(_ sender: Any) {
        updateExchangedValue()
    }
    
    private func updateExchangedValue() {
        guard let intendedAmount = Double(amountBuyingTxt.text!) else {
            exchangedValueLbl.text = "0"
            return
        }
        let exchangeRate = Double(self.exchangeRateTxt.text!)!
        exchangedValueLbl.text = "\(intendedAmount/exchangeRate)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        amountBuyingTxt.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        self.timerSubsciption?.dispose()
        print("timer invalidated")
        super.viewWillDisappear(animated)
    }
}
