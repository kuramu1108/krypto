//
//  SecondViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/29.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var CardNumberField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var ExpireDateField: UITextField!
    @IBOutlet weak var CVVField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.CardNumberField.delegate = self;
        self.NameField.delegate = self;
        self.ExpireDateField.delegate = self;
        self.CVVField.delegate = self;
        self.CardNumberField.keyboardType = UIKeyboardType.numberPad;
        self.ExpireDateField.keyboardType = UIKeyboardType.numberPad;
        self.CVVField.keyboardType = UIKeyboardType.numberPad
     
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
  
         var maxLength = 0
        
            if textField == CardNumberField {
                maxLength = 16
              
            } else if textField == NameField{
                maxLength = 20
               
            } else if textField == ExpireDateField {
                maxLength = 6
              

               
    
            } else if textField == CVVField {
                maxLength = 3
              
            }
            // this below are never executed
            
            let currentString : NSString = textField.text! as NSString
            let newString:NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        textField.keyboardType = UIKeyboardType.numberPad
            return newString.length <= maxLength
    
    }
   
  
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        CVVField.resignFirstResponder()
        ExpireDateField.resignFirstResponder()
        CardNumberField.resignFirstResponder()
    NameField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

