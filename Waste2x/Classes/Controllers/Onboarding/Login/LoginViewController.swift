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

enum BiometricType {
    case none
    case touchID
    case faceID
}

var biometricType: BiometricType {
    get {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            print(error?.localizedDescription ?? "")
            return .none
        }

        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            }
        } else {
            return  .touchID
        }
    }
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    
    //MARK:- Variables
    var apiData: String?
    var email = ""
    var password = ""
    var emailController: MDCTextInputControllerOutlined?
    var passwordController: MDCTextInputControllerOutlined?
    private var loginViewModel : LoginViewModel!
    var saveCredentials = false
    var isFingerPrintOrFaceIDEnabled: Bool {
        set {}
        get {
            return DataManager.shared.getFinger()
        }
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - SetupView
    func setupView() {
        
        self.navigationController?.navigationBar.isHidden = true
        emailController = MDCTextInputControllerOutlined(textInput: emailTextField)
        emailController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        emailController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        passwordController = MDCTextInputControllerOutlined(textInput: passwordTextField)
        passwordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        passwordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        self.emailTextField.tag = 0
        self.passwordTextField.tag = 1
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        emailController?.borderRadius = 10.0
        passwordController?.borderRadius = 10.0
        
    }
    
    
    //MARK: - IBActions
    @IBAction func faceIdPressed(_ sender: Any) {
        if biometricType == .touchID {
            showAlert(title: "", message: "Your device does not have FaceID.")
            return
        }
        saveCredentials = true
    }
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
       // keychain.delete("credentials")
       showForgotPasswordScreen()
    }
    
    @IBAction func fingerPrintAuthentication(_ sender: Any) {
        if biometricType == .faceID {
            showAlert(title: "", message: "Your device does not have TouchID.")
            return
        }
        saveCredentials = true
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        callLoginApi ()
    }
    
    @IBAction func signupTapped(_ sender: Any) {
        let signupVC = SignUpViewController(nibName: "SignUpViewController", bundle: nil)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    //MARK: - Private Methods
    func dataSource(){
        
        self.loginViewModel =  LoginViewModel()
        Utility.showLoading()
        self.loginViewModel.bindLoginViewModelToController = {
            self.updateDataSource()
        }
    }
    
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    //Move to next textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
    func updateDataSource(){
        
        self.apiData = loginViewModel.loginData
        DispatchQueue.main.async {
            Utility.hideLoading()
            self.label.text = self.apiData
            //            self.tableView.delegate = self
            //            self.tableView.reloadData()
        }
    }
    
    func callLoginApi () {
        Utility.showLoading()
       
        if self.emailTextField.text ?? "" != "" && self.passwordTextField.text ?? "" != "" {
            
            if !saveCredentials {
                self.email = self.emailTextField.text ?? ""
                self.password = self.passwordTextField.text ?? ""
            }
        }
        
        UserData.login(email: email, password: password, { (result, error, status) in
            
            if result != nil {
                UserData.shared = result!
                
                if self.saveCredentials {
                   // self.keychain.set("\(self.email),\(self.password)", forKey: "credentials")
                    DataManager.shared.setFinger(enable: true)
                }
         
            } else if result == nil {
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
                
            } else {
                self.showAlert(title: "", message: error?.localizedDescription ?? "")
            }
        })
    }
    
    private func showForgotPasswordScreen () {
        let vc = ForgotPasswordViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - APICalls
}
