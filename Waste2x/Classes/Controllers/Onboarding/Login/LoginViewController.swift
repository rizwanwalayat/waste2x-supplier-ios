//
//  LoginViewController.swift
//  Doro
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import MaterialComponents
import LocalAuthentication

class LoginViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var enterYourPhoneLabel  : UILabel!
    @IBOutlet weak var weWillSendYouLabel   : UILabel!
    @IBOutlet weak var phoneNoTextfield     : UITextField!
    
    //MARK:- Variables
   
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - SetupView
    func setupView() {
        
    }
    
    
    //MARK: - IBActions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if Utility.isTextFieldHasText(textField: phoneNoTextfield) {
            
            let codeVerificationVC = LoginCodeVerificationViewController(nibName: "LoginCodeVerificationViewController", bundle: nil)
            codeVerificationVC.enteredPhoneNumber = phoneNoTextfield.text ?? ""
            self.navigationController?.pushViewController(codeVerificationVC, animated: true)
        }
    }
}


extension LoginViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.count == 0
        {
            textField.text = "+"
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
