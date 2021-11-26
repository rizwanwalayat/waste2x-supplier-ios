//
//  LoginInputEmailViewController.swift
//  Waste2x
//
//  Created by MAC on 24/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LoginInputEmailViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var enterYourEmailLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.makeEnable(value: false)
    }


    // MARK: - Actions

    @IBAction func nextButtonPressed(_ sender: Any) {
        Registration.emailVerification(email: self.emailAddressTextField.text!) { result, error, status,message in
            
            if status  == false {
                
                Utility.showAlertController(self, message)
            }
            else if DataManager.shared.getUser()?.result?.isNewUser == true && (status == true)
            {
                guard let userInfo = DataManager.shared.getUserDetail() else {return}
                userInfo.email = self.emailAddressTextField.text!
                if let resultString = userInfo.toJSONString() {
                    
                    DataManager.shared.saveUsersDetail(resultString)
                }
                
                DataManager.shared.setUserEmail(value: self.emailAddressTextField.text!)
                let vc = SupplyingTypeViewController(nibName: "SupplyingTypeViewController", bundle: nil)
//                vc.modalPresentationStyle = .overFullScreen
//                self.present(vc, animated: false, completion: nil)
                self.navigationController?.setViewControllers([vc], animated: true)
            }
            else
            {
                Utility.showAlertController(self, message)
            }
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func textFieldValueCanged(_ sender: Any) {
        
        if Utility.isValidEmail(emailStr: emailAddressTextField.text ?? "") {
            nextButton.makeEnable(value: true)
        }
        else
        {
            nextButton.makeEnable(value: false)
        }
    }
}
