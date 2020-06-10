//
//  LoginViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/10.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginIDTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBManager.sharedInstance.userRepository.checkSampleUser()
        // Do any additional setup after loading the view.
        setupUI()
//        setupBinding()
    }
    
    private func setupUI() {
        loginIDTxt.delegate = self
        passwordTxt.delegate = self
        loginBtn.setTitleColor(UIColor.systemGray, for: .disabled)
    }
    
    @IBAction func loginAttempt(_ sender: Any) {
        if DBManager.sharedInstance.userRepository.isLoginValid(name: loginIDTxt.text!, password: passwordTxt.text!) {
            performSegue(withIdentifier: "segueLoginToHome", sender: self)
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "ID or Password Incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            self.show(alert, sender: self)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeField?.endEditing(true)
        activeField?.resignFirstResponder()
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if loginIDTxt.text!.count > 0 && passwordTxt.text!.count > 0 {
            loginBtn.isEnabled = true
            
        } else {
            loginBtn.isEnabled = false
        }
    }
}
