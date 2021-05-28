//
//  EmalPasswordViewController.swift
//  Doro
//
//  Created by a on 01/11/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import MaterialComponents

class EmalPasswordViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var emailTextField: MDCTextField!
    
    
    //MARK: - Variables
    var emailController: MDCTextInputControllerOutlined?

    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        emailController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        emailController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        emailController?.borderRadius = 10.0
    }
    
    
    //MARK: - Actions
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        emailAPI()
    }
    
    
    //MARK: - Private Methods
    private func emailAPI() {
        
        if emailTextField.isValidEmail(emailTextField.text ?? "") && emailTextField.text != "" {
            Utility.showLoading()
            UserData.forgotPassword(email: emailTextField.text!) { (data, error, status) in
                
                if error == nil {
                    
                    self.showAlert(title: "", message: data as! String)
                }
            }
        }
    }
}
