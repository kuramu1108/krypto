//
//  TransactionHistoryViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/10.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class TransactionHistoryViewController: UITableViewController {
    var account: Account!

    let df = DateFormatter()
    var selected: Transaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        df.locale = Locale.init(identifier: "en_AU")
        df.dateFormat = "dd MMM"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? ReceiptViewController else {
            return
        }
        destVC.transaction = selected
        destVC.isFromHistory = true
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account.transactions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? TransactionTVCell else {
            fatalError("unable to dequeue")
        }
        let historyCount = account.transactions.count
        // reversing list, more effiicient then resorting the list
        let transaction = account.transactions[historyCount - indexPath.item - 1]
        switch transaction.type {
        case .Deposit:
            cell.transactionIcon.image = UIImage(named: TransactionType.Deposit.rawValue)
            cell.transactionAmount.text = "+ \(transaction.inAmount)"
            cell.transactionAmount.textColor = UIColor.systemGreen
            cell.transactionDescription.text = "Deposit"
        case .Transfer:
            cell.transactionIcon.image = UIImage(named: TransactionType.Transfer.rawValue)
            cell.transactionAmount.text = "- \(transaction.outAmount)"
            cell.transactionAmount.textColor = UIColor.systemRed
            cell.transactionDescription.text = "Transfer to \(transaction.toAccount)"
        default:
            // out
            if account.name == transaction.fromAccount {
                cell.transactionAmount.text = "- \(String(format: "%.3f", transaction.outAmount))"
                cell.transactionAmount.textColor = UIColor.systemRed
            } else { // in
                cell.transactionAmount.text = "+ \(String(format: "%.3f", transaction.inAmount))"
                cell.transactionAmount.textColor = UIColor.systemGreen
            }
            cell.transactionIcon.image = UIImage(named: "Exchange")
            if transaction.type == TransactionType.Buy {
                cell.transactionDescription.text = "Buying \(transaction.inCurrency.rawValue)"
            } else { // sell
                cell.transactionDescription.text = "Selling \(transaction.outCurrency.rawValue)"
            }
        }
        cell.transactionDate.text = df.string(from: transaction.date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = account.transactions[account.transactions.count - indexPath.item - 1]
        performSegue(withIdentifier: "segueHistoryToReceipt", sender: self)
    }
}
