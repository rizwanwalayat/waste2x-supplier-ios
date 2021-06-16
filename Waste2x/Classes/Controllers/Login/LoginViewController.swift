//
//  LoginViewController.swift
//  Doro
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import LocalAuthentication

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
    }
    
    
    //MARK: - SetupView
    func setupView() {
        nextButton.makeEnable(value: false)
    }
    
    
    //MARK: - IBActions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if Utility.isTextFieldHasText(textField: phoneNoTextfield)
        {
            CodeVerification.verificationCode(phoneNumber: phoneNoTextfield.text ?? "") { result, error, status in
                if error != nil {
                    Utility.showAlertController(self, error?.localizedDescription ?? "Data not loaded")
                }
                else if result?.result != nil{
                    
                    let codeVerificationVC = LoginCodeVerificationViewController(nibName: "LoginCodeVerificationViewController", bundle: nil)
                    codeVerificationVC.phone = self.phoneNoTextfield.text ?? ""
                    self.navigationController?.pushViewController(codeVerificationVC, animated: true)
                }
                else
                {
                    Utility.showAlertController(self, error?.localizedDescription ?? "request not sent")
                }
            }
        }
    }
    }
extension LoginViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count == 0 && string != "+"
        {
            textField.text = "+"
        }
        
        if textField.text!.count > 0
        {
            nextButton.makeEnable(value: true)
        }
        else
        {
            nextButton.makeEnable(value: false)
        }
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
