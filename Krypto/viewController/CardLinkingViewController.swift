//
//  SecondViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/29.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CardLinkingViewController: UIViewController,UITextFieldDelegate {
    let vm = CardLinkingViewModel()
    let bag = DisposeBag()

    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var CardNumberField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var expiryMonth: UITextField!
    @IBOutlet weak var expiryYear: UITextField!
    @IBOutlet weak var CVVField: UITextField!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
    }
    
    func setupUI() {
        self.title = "Card Linking"
        self.CardNumberField.delegate = self
        self.NameField.delegate = self
        self.expiryMonth.delegate = self
        self.CVVField.delegate = self
        self.expiryYear.delegate = self
        self.nickname.delegate = self
        self.CardNumberField.keyboardType = UIKeyboardType.numberPad
        self.expiryMonth.keyboardType = UIKeyboardType.numberPad
        self.CVVField.keyboardType = UIKeyboardType.numberPad
    }
    
    func setupBinding() {
        vm.isValidCard
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] isValid in
                if isValid {
                    let alert = UIAlertController(title: "Card Linked", message: "You can now deposit with your card", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action) in
                        self.nickname.text = ""
                        self.CardNumberField.text = ""
                        self.NameField.text = ""
                        self.expiryMonth.text = ""
                        self.expiryYear.text = ""
                        self.CVVField.text = ""
                        return
                    }))
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Card Not Valid", message: "Please check the detail entered", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        return
                    }))
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: bag)
    }
    
    @IBAction func confirmAttempt(_ sender: Any) {
        vm.saveCard(nickname: nickname.text!, cardNumber: CardNumberField.text!, cardHolder: NameField.text!, expiryMonth: expiryMonth.text!, expiryYear: expiryYear.text!, cvv: CVVField.text!)
    }
    // MARK: - TextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        if textField == CardNumberField {
            maxLength = 16
        } else if textField == NameField{
            maxLength = 20
        } else if textField == expiryMonth {
            maxLength = 2
        } else if textField == expiryYear {
            maxLength = 2
        } else if textField == CVVField {
            maxLength = 3
        } else if textField == nickname {
            maxLength = 30
        }
        let currentString : NSString = textField.text! as NSString
        let newString:NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeField?.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

