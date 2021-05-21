//
//  CodeVerificationViewController.swift
//  Krafty
//
//  Created by Mian Faizan Nasir on 4/23/20.
//  Copyright © 2020 Mian Faizan Nasir. All rights reserved.
//

import UIKit
import Firebase

class CodeVerificationViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    //MARK: - Variables
    var email = ""
    var verificationPin = ""
    var key = ""
    var sentBy: UserType?
    var window : UIWindow?
    var verificationId = ""
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    //MARK: - View Setup
    private func setupView() {
        
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        textField5.delegate = self
        textField6.delegate = self
        
        textField2.isUserInteractionEnabled = false
        textField3.isUserInteractionEnabled = false
        textField4.isUserInteractionEnabled = false
        textField5.isUserInteractionEnabled = false
        textField6.isUserInteractionEnabled = false
        
        textField1.inputAccessoryView = UIView()
        textField2.inputAccessoryView = UIView()
        textField3.inputAccessoryView = UIView()
        textField4.inputAccessoryView = UIView()
        textField5.inputAccessoryView = UIView()
        textField6.inputAccessoryView = UIView()
        
        textField1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField5.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField6.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        (self.view.viewWithTag(1001) as! UITextField).becomeFirstResponder()
        
        verifyButton.isUserInteractionEnabled = false
        verifyButton.alpha = 0.6
        
        contentView.cornerRadius = 19
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    //MARK: - Actions
    @IBAction func verifyButtonTapped(_ sender: Any) {
        var verificationCode = textField1.text! + textField2.text! + textField3.text!
        verificationCode = verificationCode + textField4.text! + textField5.text! + textField6.text!
        
    }
    
    @IBAction func editMobileNumberButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- private methodes
    func typeDightAndMoveNext(_ textField : UITextField, text:String) {
        
        if textField == textField1 {
            textField2.isUserInteractionEnabled = true
            textField2.becomeFirstResponder()
            textField2.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
            textField2.text = text
        }
        
        if textField == textField2 {
            textField3.isUserInteractionEnabled = true
            textField3.becomeFirstResponder()
            textField3.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
            textField3.text = text
        }
        
        if textField == textField3 {
            textField4.isUserInteractionEnabled = true
            textField4.becomeFirstResponder()
            textField4.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
            textField4.text = text
        }
        
        if textField == textField4 {
            textField5.isUserInteractionEnabled = true
            textField5.becomeFirstResponder()
            textField5.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
            textField5.text = text
        }
        
        if textField == textField5 {
            textField6.isUserInteractionEnabled = true
            textField6.becomeFirstResponder()
            textField6.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
            textField6.text = text
            
            if !textField6.text!.isEmpty {
                textField6.resignFirstResponder()
                verifyButton.isUserInteractionEnabled = true
                verifyButton.alpha = 1
            } 
        }
    }
    
    //MARK: - UITextFieldDelegate
    @objc func textFieldDidChange(_ textField: UITextField) {
        let tag = textField.tag
        textField.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
        let text = textField.text!
        
        if text != "" {
            let lastChar = String(describing: Array(text)[text.count - 1])
            textField.text = lastChar + ""
        }
        
        if tag == 1006 {
            textField.resignFirstResponder()
            
        } else {
            
            if text != "" {
                (self.view.viewWithTag(tag+1) as! UITextField).isUserInteractionEnabled = true
                (self.view.viewWithTag(tag+1) as! UITextField).becomeFirstResponder()
            }
        }
        var verificationCode = textField1.text! + textField2.text! + textField3.text!
        verificationCode = verificationCode + textField4.text! + textField5.text! + textField6.text!
        
        if verificationCode.count == 6 {
            verifyButton.isUserInteractionEnabled = true
            verifyButton.alpha = 1
            
        } else {
            verifyButton.isUserInteractionEnabled = false
            verifyButton.alpha = 0.6
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var verificationCode = textField1.text! + textField2.text! + textField3.text!
        verificationCode = verificationCode + textField4.text! + textField5.text! + textField6.text!
        
        if verificationCode.count == 6 {
            
            if string == "" {
                verifyButton.isUserInteractionEnabled = false
                verifyButton.alpha = 0.6
                
            } else {
                verifyButton.isUserInteractionEnabled = true
                verifyButton.alpha = 1
            }
            
        } else {
            verifyButton.isUserInteractionEnabled = false
            verifyButton.alpha = 0.6
        }
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            textField.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 1)
            
          //  typeDightAndMoveNext(textField)
            
            textField.text = string
            return false
            
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            textField.backgroundColor = #colorLiteral(red: 0.9399999976, green: 0.9399999976, blue: 0.9399999976, alpha: 1)
            if textField == textField2 {
                textField1.becomeFirstResponder()
                textField2.isUserInteractionEnabled = false
            }
            if textField == textField3 {
                textField2.becomeFirstResponder()
                textField3.isUserInteractionEnabled = false
            }
            if textField == textField4 {
                textField3.becomeFirstResponder()
                textField4.isUserInteractionEnabled = false
            }
            if textField == textField5 {
                textField4.becomeFirstResponder()
                textField5.isUserInteractionEnabled = false
            }
            if textField == textField6 {
                textField5.becomeFirstResponder()
                textField6.isUserInteractionEnabled = false
            }
            if textField == textField1 {
                textField1.resignFirstResponder()
            }
            textField.text = ""
            return false
            
            
        } else if (textField.text?.count)! >= 1 {
            typeDightAndMoveNext(textField, text: string)
           // textField.text = string
           
            return false
        }
        
        
        return true
    }
}


//MARK: - APICalls
