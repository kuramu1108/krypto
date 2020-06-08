//
//  TransactionTVCell.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/8.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class TransactionTVCell: UITableViewCell {
    @IBOutlet weak var transactionIcon: UIImageView!
    @IBOutlet weak var transactionDescription: UILabel!
    @IBOutlet weak var transactionAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
