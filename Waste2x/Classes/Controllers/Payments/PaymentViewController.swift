//
//  PaymentViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 31/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
