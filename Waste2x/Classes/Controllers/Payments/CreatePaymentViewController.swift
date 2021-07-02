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
    @IBOutlet weak var bottomConst: NSLayoutConstraint!
    @IBOutlet weak var informationText: UILabel!
    @IBOutlet weak var emailStackView: UIStackView!
    var id : String?
    var email : String?
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.idTitle.text = Global.shared.paymentModel?.result?.accountId
        if Global.shared.paymentModel?.result?.email == "" {
            self.informationText.attributedText = setAttributedTextInLable(text1:"Your Stripe account is\n",text2: "exist but not Verified",size: 18)
            self.emailStackView.isHidden = true
        }
        else
        {
            self.informationText.attributedText = setAttributedTextInLable(text1:"Your payment account is\n",text2: "Already exist",size: 20)
            self.emailTitle.text = Global.shared.paymentModel?.result?.email
            self.emailStackView.isHidden = false
        }
            
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        mainView.layer.cornerRadius = 36
        mainView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainView.layer.masksToBounds = true
        globalObjectContainer?.tabbarHiddenView.isHidden = false
        bottomConst.constant = tabbarViewHeight
        

    }
    override func viewWillLayoutSubviews() {
        super .viewWillLayoutSubviews()
        

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
