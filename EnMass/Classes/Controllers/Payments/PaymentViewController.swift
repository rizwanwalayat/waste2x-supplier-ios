//
//  PaymentViewController.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 31/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class PaymentViewController: BaseViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        bottomConst.constant = tabbarViewHeight
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func connectStripeAccount(_ sender: Any) {
        //Utility.homeViewController()
        CreatePaymentModel.CreatePaymentApiFunction{ result, error, status,message in
//            if let url = URL(string: "\(result!.result)") {
//                UIApplication.shared.open(url)
//            }
        
            let vcHome = HomeNewViewController(nibName: "HomeNewViewController", bundle: nil)
            let vc = WebViewViewController(nibName: "WebViewViewController", bundle: nil)
            vc.urlString = result!.result // "https://www.google.com/"
            
            self.navigationController?.setViewControllers([vcHome, vc], animated: true)
        }
    }
}
