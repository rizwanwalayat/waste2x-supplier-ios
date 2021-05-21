//
//  ForgotPasswordViewController.swift
//  Doro
//
//  Created by a on 09/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import MaterialComponents

class ForgotPasswordViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var newPasswordTextField: MDCTextField!
    @IBOutlet weak var confirmNewPasswordTextField: MDCTextField!
    
    
    //MARK: - Variables
    var newPasswordController: MDCTextInputControllerOutlined?
    var confirmPasswordController: MDCTextInputControllerOutlined?
    
    
    //MARK: - Llifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View setup
    func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        newPasswordController = MDCTextInputControllerOutlined(textInput: newPasswordTextField)
        newPasswordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        newPasswordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
       // confirmPasswordController = MDCTextInputControllerOutlined(textInput: confirmNewPasswordTextField)
       // confirmPasswordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
      //  confirmPasswordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        newPasswordController?.borderRadius = 10.0
     //   confirmPasswordController?.borderRadius = 10.0
        
    }
    
    
    //MARK: - IBActions
    @IBAction func doneTapped(_ sender: Any) {
        
        UserData.forgotPassword(email: newPasswordTextField.text ?? "") { (data, error, status) in
            
            if error == nil {
                self.showAlert(title: "", message:"You have received an email regarding forgot password. Please check!")
            } else {
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
            }
        }
       
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
