//
//  LoginViewController.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit
//import LocalAuthentication

class LoginViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var enterYourPhoneLabel  : UILabel!
    @IBOutlet weak var weWillSendYouLabel   : UILabel!
    @IBOutlet weak var phoneNoTextfield     : UITextField!
    @IBOutlet weak var nextButton           : UIButton!
    
    //MARK:- Variables
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationController?.navigationBar.isHidden = true
        phoneNoTextfield.text = "+1"
    }
    
    
    //MARK: - SetupView
    func setupView() {
        nextButton.makeEnable(value: false)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if Utility.isTextFieldHasText(textField: phoneNoTextfield)
        {
            if !phoneNoTextfield.text!.contains("+"){
                
                
                CodeVerification.verificationCode(phoneNumber: "+1" + phoneNoTextfield.text!) { result, error, status,message in
                    
                    if error == nil {
                        let codeVerificationVC = LoginCodeVerificationViewController(nibName: "LoginCodeVerificationViewController", bundle: nil)
                        Global.shared.phoneNumber = self.phoneNoTextfield.text!
                        self.navigationController?.pushViewController(codeVerificationVC, animated: true)
                    }
                    else {
                        
                        Utility.showAlertController(self, error!.localizedDescription)
                        
                    }
                }
                
            }
            else {
                CodeVerification.verificationCode(phoneNumber: phoneNoTextfield.text!) { result, error, status,message in
                    
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
}
    
extension LoginViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if string == "" && (textField.text!.count < 3)
//        {
//           return false
//        }
        
        return true
    }
}




//enum BiometricType {
//    case none
//    case touchID
//    case faceID
//}
//
//var biometricType: BiometricType {
//    get {
//        let context = LAContext()
//        var error: NSError?
//
//        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
//            print(error?.localizedDescription ?? "")
//            return .none
//        }
//
//        if #available(iOS 11.0, *) {
//            switch context.biometryType {
//            case .none:
//                return .none
//            case .touchID:
//                return .touchID
//            case .faceID:
//                return .faceID
//            }
//        } else {
//            return  .touchID
//        }
//    }
//}
