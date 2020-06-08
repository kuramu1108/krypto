//
//  FirstViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/5/29.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

class HomeViewController: UIViewController {
    var timer: Timer?
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var transactionTV: UITableView!
    
    let cardHeightScale: CGFloat = 0.6
    let cardWidthScale: CGFloat = 0.8
    var previousOffset: CGFloat = 0
    var currentItem: Int = 0
     
    
    var vm = HomeViewModel()
    let disposeBag = DisposeBag()
    var currentAccount: Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "can not obtain default config url")
        // Do any additional setup after loading the view.
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cardWidthScale)
        let cellHeight = floor(cardCollectionView.bounds.height * cardHeightScale)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (cardCollectionView.bounds.height - cellHeight) / 2.0
        
        let layout = cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        cardCollectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        transactionTV.delegate = self
        transactionTV.dataSource = self
    }
    
    private func setupBindings() {
        vm.currentAccount
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] account in
                if account.currency == Currency.USD {
                    self.exchangeBtn.isEnabled = false
                } else {
                    self.exchangeBtn.isEnabled = true
                }
                
                if let currentAccount = self.currentAccount {
                    if currentAccount != account {
                        self.transactionTV.reloadData()
                        self.cardCollectionView.reloadData()
                    }
                }
                self.currentAccount = account
            })
            .disposed(by: disposeBag)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue" {
            guard let destinationVC = segue.destination as? ExchangeViewController else {
                return
            }
            let fromAcc = vm.requestAccount(currency: Currency.USD)
            let toAcc = vm.currentAccount.value
            destinationVC.evm = ExchangeViewModel(fromAcc: fromAcc, toAcc: toAcc)
        }
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        cardCollectionView.reloadData()
        transactionTV.reloadData()
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.accounts.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        cell.account = vm.accounts.value[indexPath.item]
        return cell
    }
   
}

extension HomeViewController: UICollectionViewDelegate {
    // snapping reference: https://medium.com/@shaibalassiano/tutorial-horizontal-uicollectionview-with-paging-9421b479ee94
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfProposedCell = indexOfPropsedCell()
        let indexPath = IndexPath(row: indexOfProposedCell, section: 0)
        let layout = self.cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        vm.switchAccount(to: indexOfProposedCell)
    }
    
    func indexOfPropsedCell() -> Int {
        let layout = self.cardCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = layout.itemSize.width
        let proportionalOffset = layout.collectionView!.contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(vm.accounts.value.count - 1, index))
        return safeIndex
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.currentAccount.value.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "HomeTransactionCell"
        guard let cell = transactionTV.dequeueReusableCell(withIdentifier: id, for: indexPath) as? TransactionTVCell else {
            fatalError("unable to dequeue")
        }
        let transaction = vm.currentAccount.value.transactions[indexPath.item]
        switch transaction.type {
        case .Deposit:
            cell.transactionIcon.image = UIImage(named: TransactionType.Deposit.rawValue)
            cell.transactionAmount.text = "+ \(transaction.inAmount)"
            cell.transactionAmount.textColor = UIColor.systemGreen
        case .Transfer:
            cell.transactionIcon.image = UIImage(named: TransactionType.Transfer.rawValue)
            cell.transactionAmount.text = "- \(transaction.outAmount)"
            cell.transactionAmount.textColor = UIColor.systemRed
        default:
            // out
            if vm.currentAccount.value.name == transaction.fromAccount {
                cell.transactionAmount.text = "- \(String(format: "%.3f", transaction.outAmount))"
                cell.transactionAmount.textColor = UIColor.systemRed
            } else { // in
                cell.transactionAmount.text = "+ \(String(format: "%.3f", transaction.inAmount))"
                cell.transactionAmount.textColor = UIColor.systemGreen
            }
            cell.transactionIcon.image = UIImage(named: "Exchange")
        }
        return cell
    }
}
