//
//  LoginCodeVerificationViewController.swift
//  Waste2x
//
//  Created by MAC on 24/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LoginCodeVerificationViewController: BaseViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var enterCodeSendsToYourPhoneLabel   : UILabel!
    @IBOutlet weak var sendsConfirmationCodeLabel       : UILabel!
    @IBOutlet weak var firstTextField                   : UITextField!
    @IBOutlet weak var secondTextField                  : UITextField!
    @IBOutlet weak var thirdTextField                   : UITextField!
    @IBOutlet weak var fourthTextField                  : UITextField!
    @IBOutlet weak var resendCodeButton                 : UIButton!
    @IBOutlet weak var securityCodeView                 : UIView!
    @IBOutlet weak var nextButton                       : UIButton!
    
    
    //MARK: - Variables
    let device = UIDevice()
//    var phone = ""
    let model = UIDevice.modelName
    
    var enteredPhoneNumber = ""
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributedTextInLable(phoneNo: enteredPhoneNumber)
        nextButton.makeEnable(value: false)
        firstTextField.becomeFirstResponder()
    }

    //MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        let code = firstTextField.text! + secondTextField.text! + thirdTextField.text! + fourthTextField.text!
        print(code)
        let os = device.systemVersion
        Registration.verificationCode(phone: Global.shared.phoneNumber, code: code, latitude: Global.shared.current_lat, longitude: Global.shared.current_lng, firebase_token: Global.shared.fireBaseToken, phone_imei: 123456789, phone_os: os, phone_model: model) { result, error, status,message in
            
            if error != nil{
                
                Utility.showAlertController(self, message)
                
            }
            
            else if result?.result != nil {
                
                
                let convretedData = result!.toJSONString()
                DataManager.shared.setUser(user: convretedData ?? "")
                
                if DataManager.shared.getUser()?.result?.isNewUser == false {
                    
                    let slider = SlideMenuController(mainViewController: ContainerViewController(), leftMenuViewController: SideMenuViewController())
                    self.navigationController?.setViewControllers([slider], animated: true)
                }
                else {
                    
                    let codeVerificationVC = LoginInputEmailViewController(nibName: "LoginInputEmailViewController", bundle: nil)
                    self.navigationController?.pushViewController(codeVerificationVC, animated: true)
                }
                                
            }
            else{
                Utility.showAlertController(self, message)
                
            }
        }
    }
    
    @IBAction func resendCodeButtonPressed(_ sender: Any) {
        CodeVerification.verificationCode(phoneNumber: Global.shared.phoneNumber) { result, error, status, message in
            
            if error == nil {
                self.showToast(message: message)
            }
            else{
                Utility.showAlertController(self, error!.localizedDescription)
                
            }
        }
    }
    
}

//MARK: - TextField Delegate Methods 

extension LoginCodeVerificationViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return adjustTextInPut(textfieldTag: textField.tag, newText: string)
    }
}
