//
//  TransferViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/2.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftSpinner

class TransferViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var accountPicker: UIPickerView!
    @IBOutlet weak var selectedAccountNameLbl: UILabel!
    @IBOutlet weak var selectedAccountBalanceLbl: UILabel!
    @IBOutlet weak var amountSendingTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var vm = TransferViewModel()
    let bag = DisposeBag()
    
    var selectedTxtField: UITextField?
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let randomRow = Int.random(in: 0..<vm.accountContacts.count)
        accountPicker.selectRow(randomRow, inComponent: 1, animated: true)
        vm.setSelectedAccountContact(randomRow)
    }
    
    private func setupUI() {
        accountPicker.delegate = self
        accountPicker.dataSource = self
        amountSendingTxt.delegate = self
    }
    
    private func setupBinding() {
        vm.selectedAccount
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] account in
                self.selectedAccountNameLbl.text = account.name
                self.selectedAccountBalanceLbl.text = String(account.balance)
            })
            .disposed(by: bag)
        
        vm.trading
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] trading in
                if trading {
                    SwiftSpinner.show("Sending Money")
                } else {
                    SwiftSpinner.hide()
                    self.performSegue(withIdentifier: "segueToTransferComplete", sender: self)
                }
                
            })
            .disposed(by: bag)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(TransferViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default
            .addObserver(self, selector: #selector(TransferViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ReceiptViewController else {
            return
        }
        destVC.transaction = vm.transaction
    }
    
    // MARK: - Button
    @IBAction func transfer(_ sender: Any) {
        print("transfer fire")
        guard let amountSending = Double(amountSendingTxt.text!) else {
            return
        }
        guard amountSending <= vm.selectedAccount.value.balance else {
            // add alert
            print("not enough found")
            return
        }
        vm.transfer(amountSending)
    }
    
    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return vm.accounts.count
        }
        return vm.accountContacts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return vm.accounts[row].name
        } else {
            return vm.accountContacts[row].ownerName
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            vm.setSelectedAccount(row)
        } else {
            vm.setSelectedAccountContact(row)
        }
    }
    // MARK: - TextField
    // combining reference from the following
    // https://fluffy.es/move-view-when-keyboard-is-shown/#tldrscroll
    // https://medium.com/@andy.nguyen.1993/autolayout-for-scrollview-keyboard-handling-in-ios-5a47d73fd023
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        selectedTxtField = textField
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        selectedTxtField?.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
        // increase height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        keyboardHeight = nil
    }
}
