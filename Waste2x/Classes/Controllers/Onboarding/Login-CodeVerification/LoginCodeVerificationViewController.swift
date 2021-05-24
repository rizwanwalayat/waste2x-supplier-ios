//
//  LoginCodeVerificationViewController.swift
//  Waste2x
//
//  Created by MAC on 24/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class LoginCodeVerificationViewController: UIViewController {

    //MARK:- IBOutlets
    
    @IBOutlet weak var enterCodeSendsToYourPhoneLabel   : UILabel!
    @IBOutlet weak var sendsConfirmationCodeLabel       : UILabel!
    @IBOutlet weak var firstTextField                   : UITextField!
    @IBOutlet weak var secondTextField                  : UITextField!
    @IBOutlet weak var thirdTextField                   : UITextField!
    @IBOutlet weak var fourthTextField                  : UITextField!
    @IBOutlet weak var resendCodeButton                 : UIButton!
    @IBOutlet weak var securityCodeView                 : UIView!
    
    
    //MARK: - Variables
    
    var enteredPhoneNumber = ""
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setAttributedTextInLable(phoneNo: enteredPhoneNumber)
    }


    func setAttributedTextInLable(phoneNo :String)
    {
        let loginWithfont       = UIFont(name: "", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let activityAttribute   = [ NSAttributedString.Key.font: loginWithfont, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "B3B2B2")]
        let nameAttrString      = NSMutableAttributedString(string: "We sent you an code on: ", attributes: activityAttribute)
        
        let nameFont            = UIFont(name: "", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let nameAttribute       = [ NSAttributedString.Key.font: nameFont, NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "000000")]
        let activityAttrString  = NSAttributedString(string: phoneNo, attributes: nameAttribute)
        
        nameAttrString.append(activityAttrString)
        
        sendsConfirmationCodeLabel.attributedText = nameAttrString
    }

    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
    @IBAction func resendCodeButtonPressed(_ sender: Any) {
    }
    
}

//MARK: - TextField Delegate Methods 

extension LoginCodeVerificationViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return adjustTextInPut(textfieldTag: textField.tag, newText: string)
    }
}
