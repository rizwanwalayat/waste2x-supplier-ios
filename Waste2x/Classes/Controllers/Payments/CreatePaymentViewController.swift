//
//  CreatePaymentViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 01/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class CreatePaymentViewController: BaseViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var idTitle: UITextField!
    @IBOutlet weak var emailTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        self.idTitle.text = Data?.stripe_account_name
        self.emailTitle.text = Data?.email
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
