//
//  CodeVerificationViewModel.swift
//  Waste2x
//
//  Created by MAC on 24/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit

extension LoginCodeVerificationViewController
{
    func adjustTextInPut (textfieldTag:Int, newText:String) -> Bool {
        
        let currentField    = getTextFieldWithTag(textfieldTag)
        
        
        if(newText != "") {
            if((currentField.text?.count)! > 0) {
                currentField .resignFirstResponder()
                currentField .isUserInteractionEnabled = false
                
                if(textfieldTag != 4) {
                    let nextField = getTextFieldWithTag(textfieldTag+1)//securityCodeView.viewWithTag(textfieldTag+1) as! UITextField
                    nextField .isUserInteractionEnabled = true
                    nextField .becomeFirstResponder()
                    nextField.text = newText
                    nextField.background = nil
                    
                    if nextField.tag == 6 {
                        nextField .resignFirstResponder()
                        self.nextButtonCalled()
                    }
                }
                
                return false
            }
            else {
                
                currentField.background = nil
            }
        }
        else {
            //currentField.background = #imageLiteral(resourceName: "dash-line")
            currentField.text = ""
            if(textfieldTag != 1) {
                currentField .isUserInteractionEnabled = false
            }
            
            let nTag = textfieldTag-1
            if(nTag > 0) {
                let previewField = getTextFieldWithTag(nTag)//securityCodeView.viewWithTag(nTag) as! UITextField
                previewField .isUserInteractionEnabled = true
                previewField.becomeFirstResponder()
                return false
            }
        }
        
        return true
    }
    
    /**************************************************/
    
    func getTextFieldWithTag (_ tag : Int) -> UITextField
    {
        let stackView       = securityCodeView.subviews.first as! UIStackView //viewWithTag(textfieldTag)
        let subView         = stackView.viewWithTag(tag)
        let currentField    = subView?.subviews.first as! UITextField
        return currentField
    }
    
    /**************************************************/
    
    func nextButtonCalled()
    {
        if isFieldsHasValidInput()
        {
            
            let verificationCode    = "\(firstTextField.text!)\(secondTextField.text!)\(thirdTextField.text!)\(fourthTextField.text!)"
        }
        else
        {
            self.alertview(title: "Error", message: "please enter all fields")
        }
    }
    
    func isFieldsHasValidInput() -> Bool {

        if Utility.isTextFieldHasText(textField: firstTextField) == false{
            return false
        }
        if Utility.isTextFieldHasText(textField: secondTextField) == false{
            return false
        }
        if Utility.isTextFieldHasText(textField: thirdTextField) == false{
            return false
        }
        if Utility.isTextFieldHasText(textField: fourthTextField) == false{
            return false
        }
        return true
    }
    
    func alertview(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
