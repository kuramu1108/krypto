//
//  ExchangeCompleteViewController.swift
//  Krypto
//
//  Created by Po-Hao Chen on 2020/6/5.
//  Copyright © 2020 Po-Hao Chen. All rights reserved.
//

import UIKit

class ExchangeCompleteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func done(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
}
