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

    @IBOutlet weak var tradingModeLbl: UILabel!
    
    @IBOutlet weak var currencyTradingTxt: UILabel!
    @IBOutlet weak var amountBuyingTxt: UITextField!
    @IBOutlet weak var rateUpdatingTimeTxt: UILabel!
    
    @IBOutlet weak var exchangedValueLbl: UILabel!
    @IBOutlet weak var exchangedValueCurrencyLbl: UILabel!
    
    @IBOutlet weak var fromAccountNameLbl: UILabel!
    @IBOutlet weak var fromAccountBalanceLbl: UILabel!
    
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
        evm.refreshCounter
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] counter in
                if counter > 5 {
                    self.timerSubsciption?.dispose()
                }
            })
            .disposed(by: disposeBag)
        
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
        
        evm.isBuying
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] isBuying in
                if isBuying {
                    self.tradingModeLbl.text = "Buying"
                    self.tradingModeLbl.textColor = UIColor.systemBlue
                    self.amountBuyingTxt.backgroundColor = UIColor.systemBlue
                } else {
                    self.tradingModeLbl.text = "Selling"
                    self.tradingModeLbl.textColor = UIColor.systemRed
                    self.amountBuyingTxt.backgroundColor = UIColor.systemRed
                }
                self.amountBuyingTxt.placeholder = self.tradingModeLbl.text
                self.fromAccountNameLbl.text = self.evm.fromAccount.name
                self.fromAccountBalanceLbl.text = "$\(String(self.evm.fromAccount.balance)) \(self.evm.fromAccount.currency.rawValue)"
                self.exchangedValueCurrencyLbl.text = self.evm.toAccount.currency.rawValue
                self.amountBuyingTxt.text = ""
                self.updateExchangedValue()
            })
            .disposed(by: disposeBag)
        
        let repeatTimer = Observable<Int>
            .timer(.seconds(0), period: .seconds(Constants.RateUpdateInterval), scheduler: MainScheduler.instance)
            .flatMap { [unowned self] _ in
                return self.evm.requestRate()
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
                self.evm.refreshIncrement()
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
        
        // static views
        baseCurrencyLbl.text = "1 \(evm.baseCurrency.rawValue ) ="
        quoteCurrencyLbl.text = evm.quoteCurrency.rawValue
        currencyTradingTxt.text = evm.baseCurrency.rawValue
        
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
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ReceiptViewController else {
            return
        }
        destinationVC.transaction = evm.transaction
    }
    
    // MARK: - UIActions
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
        let equivalentAmount = Double(exchangedValueLbl.text!)!
        evm.exchange(amount: intendedAmount, equivalentAmount: equivalentAmount,rate: exchangeRate)
    }
    
    @IBAction func amountChanged(_ sender: Any) {
        updateExchangedValue()
    }
    
    @IBAction func swapTrading(_ sender: Any) {
        evm.swapTradingMode()
    }
    
    private func updateExchangedValue() {
        guard let intendedAmount = Double(amountBuyingTxt.text!) else {
            exchangedValueLbl.text = "0"
            return
        }
        let exchangeRate = Double(self.exchangeRateTxt.text!)!
        
        if evm.isBuying.value {
            exchangedValueLbl.text = "\(intendedAmount/exchangeRate)"
        } else {
            exchangedValueLbl.text = "\(intendedAmount * exchangeRate)"
        }
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
