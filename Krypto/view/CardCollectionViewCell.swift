//
//  CardCollectionViewCell.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/7.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountCurrency: UIImageView!
    @IBOutlet weak var bg: UIView!
    
    var account: Account! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let account = account {
            accountName.text = account.name
            if account.currency == Currency.USD {
                accountBalance.text = String(format: "%.2f", account.balance)
            } else {
                accountBalance.text = String(format: "%.6f", account.balance)
            }
            accountCurrency.image = UIImage(named: account.currency.rawValue)
            bg.layer.cornerRadius = 10.0
            bg.layer.masksToBounds = false
        }
    }
}
