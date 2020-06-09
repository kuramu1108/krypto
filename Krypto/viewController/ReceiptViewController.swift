//
//  ReceiptViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/5.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    var transaction: Transaction!

    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var amount1Stack: UIStackView!
    @IBOutlet weak var amount2Stack: UIStackView!
    @IBOutlet weak var amount1Lbl: UILabel!
    @IBOutlet weak var amount2Lbl: UILabel!
    @IBOutlet weak var amount1Value: UILabel!
    @IBOutlet weak var amount2Value: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        uiBinding()
    }
    
    private func uiBinding() {
        let type = transaction.type
        typeLbl.text = type.rawValue
        
        switch type {
        case TransactionType.Deposit:
            amount1Lbl.text = "Amount"
            amount1Value.text = String(transaction.inAmount)
            amount2Stack.isHidden = true
        case TransactionType.Transfer:
            amount1Lbl.text = "Amount"
            amount1Value.text = String(transaction.outAmount)
            amount2Stack.isHidden = true
        case TransactionType.Buy:
            amount1Lbl.text = "Buying"
            amount1Value.text = "\(String(format: "%.3f", transaction.inAmount)) \(transaction.inCurrency.rawValue)"
            amount2Lbl.text = "With"
            amount2Value.text = "$ \(String(format: "%.3f", transaction.outAmount))"
        case TransactionType.Sell:
            amount1Lbl.text = "Selling"
            amount1Value.text = "\(String(format: "%.3f", transaction.outAmount)) \(transaction.outCurrency.rawValue)"
            amount2Lbl.text = "For"
            amount2Value.text = "$ \(String(format: "%.3f", transaction.inAmount))"
        }
        
        fromLbl.text = transaction.fromAccount
        toLbl.text = transaction.toAccount
        let df = DateFormatter()
        df.locale = Locale.init(identifier: "en_AU")
        df.dateFormat = "d MMM yyyy HH:mm"
        dateLbl.text = df.string(from: transaction.date)
    }

    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
}
