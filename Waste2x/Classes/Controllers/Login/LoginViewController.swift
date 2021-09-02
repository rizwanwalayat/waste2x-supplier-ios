//
//  LoginViewController.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import UIKit
import ADCountryPicker
//import LocalAuthentication

class LoginViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var enterYourPhoneLabel  : UILabel!
    @IBOutlet weak var weWillSendYouLabel   : UILabel!
    @IBOutlet weak var phoneNoTextfield     : UITextField!
    @IBOutlet weak var nextButton           : UIButton!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    @IBOutlet weak var countryDialCodeLbl: UILabel!
    
    //MARK:- Variables
    var picker = ADCountryPicker()

    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.navigationController?.navigationBar.isHidden = true
        setupCountryPicker()
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

        self.present(picker, animated: true, completion: nil)

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

extension LoginViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        picker.dismiss(animated: true, completion: nil)
        if let flagImage = picker.getFlag(countryCode: code){
            countryFlagImgView.image = flagImage
        }
        else if code == "US" {
            countryFlagImgView.image = UIImage(named: "US Flag Local")
        }
        countryDialCodeLbl.text = dialCode
    }
    
    func setupCountryPicker(){
        picker.delegate = self
        picker.showCallingCodes = true
        picker.defaultCountryCode = "US"
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
