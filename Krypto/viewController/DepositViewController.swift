//
//  DepositViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/8.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftSpinner

class DepositViewController: UIViewController {
    @IBOutlet weak var paymentMethodTxt: UITextField!
    @IBOutlet weak var amountDepositingTxt: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var accountNameLbl: UILabel!
    
    var vm: DepositViewModel!
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        let paymentPicker = UIPickerView()
        paymentPicker.delegate = self
        paymentPicker.dataSource = self
        accountNameLbl.text = vm.toAccount.name
        paymentMethodTxt.inputView = paymentPicker
//        paymentMethodTxt.text = vm.mockCards[0].name
    }
    
    private func setupBinding() {
        vm.cards
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] cards in
                if cards.count == 0 {
                    self.paymentMethodTxt.placeholder = "No card linked to your account"
                    self.paymentMethodTxt.isEnabled = false
                }
            })
            .disposed(by: bag)
        
        vm.loading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] loading in
                if loading {
                    SwiftSpinner.show("Processing")
                } else {
                    SwiftSpinner.hide()
                    self.performSegue(withIdentifier: "segueToDepositComplete", sender: self)
                }
            })
            .disposed(by: bag)
        
        vm.selectedCard
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] card in
                if card != nil {
                    self.confirmBtn.isEnabled = true
                }
            })
            .disposed(by: bag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func deposit(_ sender: Any) {
        guard let amountDepositing = Double(amountDepositingTxt.text!) else {
            return
        }
        vm.deposit(amountDepositing)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ReceiptViewController else {
            return
        }
        destinationVC.transaction = vm.transaction
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        paymentMethodTxt.endEditing(true)
        amountDepositingTxt.endEditing(true)
    }

}

extension DepositViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vm.mockCards.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vm.mockCards[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        paymentMethodTxt.text = vm.cards.value[row].name
        vm.selectCard(at: row)
    }
}
