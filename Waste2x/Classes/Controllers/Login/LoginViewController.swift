//
//  LoginViewController.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit
import Columbus
//import LocalAuthentication

class LoginViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var enterYourPhoneLabel  : UILabel!
    @IBOutlet weak var weWillSendYouLabel   : UILabel!
    @IBOutlet weak var phoneNoTextfield     : UITextField!
    @IBOutlet weak var nextButton           : UIButton!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    @IBOutlet weak var countryDialCodeLbl: UILabel!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: - SetupView
    func setupView() {
        nextButton.makeEnable(value: false)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if Utility.isTextFieldHasText(textField: phoneNoTextfield)
        {
            let completePhoneNo = "\(countryDialCodeLbl.text ?? "")\(phoneNoTextfield.text ?? "")"
            
            
                CodeVerification.verificationCode(phoneNumber: completePhoneNo) { result, error, status,message in
                    
                    if error == nil {
                        let codeVerificationVC = LoginCodeVerificationViewController(nibName: "LoginCodeVerificationViewController", bundle: nil)
                        Global.shared.phoneNumber = self.phoneNoTextfield.text ?? ""
                        self.navigationController?.pushViewController(codeVerificationVC, animated: true)
                    }
                    else {
                        
                        Utility.showAlertController(self, error!.localizedDescription)
                        
                    }
                }
        }
    }
    
    
    @IBAction func phoneTextFieldValueCanged(_ sender: Any) {
        
        if phoneNoTextfield.text!.count > 0
        {
            nextButton.makeEnable(value: true)
        }
        else
        {
            nextButton.makeEnable(value: false)
        }
    }
    @IBAction func countryCodeBtnPressed(_ sender: Any) {

        let countryPicker = CountryPickerViewController(config: CountryPickerConfig(),
                                                        initialCountryCode: "US") { (country) in
            
            self.dismiss(animated: true) {
                self.countryFlagImgView.image = country.flagIcon
                self.countryDialCodeLbl.text = "+\(country.dialingCode)"
            }
        }
        present(countryPicker, animated: true)

    }
}
