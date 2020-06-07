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
    var vm = HomeViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var featureScrollView: UIScrollView!
    let feature1 = ["title":"Bitcoin","balance":"30","image":"1"]
    let feature2 = ["title":"ETH","balance":"40","image":"2"]
    let feature3 = ["title":"XRP","balance":"50","image":"3"]
    var featureArray = [Dictionary<String,String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       featureArray = [feature1,feature2,feature3]
        featureScrollView.isPagingEnabled = true
        featureScrollView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(featureArray.count), height: 250)
        featureScrollView.showsHorizontalScrollIndicator = false
        
        loadFeatures()
        
        
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "can not obtain default config url")
        // Do any additional setup after loading the view.
        setupBindings()
    }

func loadFeatures() {
    for(index,feature) in featureArray.enumerated() {
        if let featureView = Bundle.main.loadNibNamed("Feature", owner: self, options: nil)?.first as? FeatureView {
                featureView.featureImageView.image = UIImage(named: feature["image"]!)
                featureView.titleLabel.text = feature["title"]
                featureView.balanceLabel.text = feature["balance"]
                
                featureScrollView.addSubview(featureView)
                featureView.frame.size.width = self.view.bounds.size.width
                featureView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
            }
        }
    }
    private func setupBindings() {
        vm.accounts
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] results in
                if results.count == 0 {
                    self.vm.initSampleAccounts()
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "exchangeSegue" {
            guard let destinationVC = segue.destination as? ExchangeViewController else {
                return
            }
            let fromAcc = vm.requestAccount(currency: Currency.USD)
            let toAcc = vm.requestAccount(currency: Currency.BTC)
            destinationVC.evm = ExchangeViewModel(fromAcc: fromAcc, toAcc: toAcc)
        }
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        
    }
}



