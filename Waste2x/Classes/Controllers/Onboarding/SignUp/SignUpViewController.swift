//
//  SignUpViewController.swift
//  Doro
//
//  Created by a on 05/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import UIKit
import MaterialComponents
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: - Outlets
    @IBOutlet weak var doneeSignupView: UIView!
    @IBOutlet weak var donorSignUpView: UIView!
    @IBOutlet weak var doneeButton: UIButton!
    @IBOutlet weak var donorButton: UIButton!
    @IBOutlet weak var doneeFullnameTextField: MDCTextField!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var doneeEmailTextField: MDCTextField!
    @IBOutlet weak var doneePaypalEmailTextField: MDCTextField!
    @IBOutlet weak var doneePhoneNoTextField: MDCTextField!
    @IBOutlet weak var doneeNationalID: MDCTextField!
    @IBOutlet weak var doneeSocialSecurityNoTextField: MDCTextField!
    
    @IBOutlet weak var doneeOccupationTextField: MDCTextField!
    @IBOutlet weak var doneePasswordTextField: MDCTextField!
    @IBOutlet weak var doneeConfirmPasswordTextField: MDCTextField!
    @IBOutlet weak var donorFullNameTextField: MDCTextField!
    @IBOutlet weak var donorEmailTextField: MDCTextField!
    
    @IBOutlet weak var donorPhoneNoTextField: MDCTextField!
    @IBOutlet weak var donorOccupationTextField: MDCTextField!
    @IBOutlet weak var donorPasswordTextField: MDCTextField!
    @IBOutlet weak var donorConfirmPasswordTextField: MDCTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK: - Variables
    var doneeFullnameController: MDCTextInputControllerOutlined?
    var doneeEmailController: MDCTextInputControllerOutlined?
    var doneePaypalEmailController: MDCTextInputControllerOutlined?
    var doneePhoneNoController: MDCTextInputControllerOutlined?
    var doneeNationalIdController: MDCTextInputControllerOutlined?
    
    var doneeSSNController: MDCTextInputControllerOutlined?
    var doneeOccupationController: MDCTextInputControllerOutlined?
    var doneePasswordController: MDCTextInputControllerOutlined?
    var doneeConfirmPasswordController: MDCTextInputControllerOutlined?
    var donorFullnameController: MDCTextInputControllerOutlined?
    var donorEmailController: MDCTextInputControllerOutlined?
    
    var donorPhoneNoController: MDCTextInputControllerOutlined?
    var donorOccupationController: MDCTextInputControllerOutlined?
    var donorPasswordController: MDCTextInputControllerOutlined?
    var donorConfirmPasswordController: MDCTextInputControllerOutlined?
    var window: UIWindow?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadView()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    
    //MARK: - SetupView
    func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        donorSignUpView.isHidden = true        
        settingAllTextFieldColors()
        settingTextFieldBorders()
        setUIForDonee()
        setUIForDonor()
    }
    
    
    //MARK: - IBActions
    @IBAction func doneeTapped(_ sender: UIButton) {
        setDoneeState()
        contentViewHeightConstraint.constant = 1100
    }
    
    @IBAction func donorTapped(_ sender: UIButton) {
        setDonorState()
        contentViewHeightConstraint.constant = 850
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        
        if validateFields() {
            codeVerificationScreen(sentBy: .donor)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        if validateFields() {
            codeVerificationScreen(sentBy: .donee)
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


    //MARK: - Private methods
    private func tagBasedTextField(_ textField: UITextField) {
        let nextTextFieldTag = textField.tag + 1

        if let nextTextField = textField.superview?.viewWithTag(nextTextFieldTag) as? UITextField {
            nextTextField.becomeFirstResponder()
            
        } else {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func tapToValidate(_ sender: Any) {
        tapValidate = true
        self.showAlert(title: "", message: "Validations Set")
    }
    
    @IBAction func cancelValidationButton(_ sender: Any) {
        tapValidate = false
        tapToCancel = true
        self.showAlert(title: "", message: "Validations Off")
    }
    
    //Move to next textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tagBasedTextField(textField)
        return true
    }
    
    
    //MARK: - Private Methods
    private func codeVerificationScreen (sentBy: UserType = .donee) {
        
        var requestObj: [String: String] = [:]
        
        
        var phone = ""
        
        if sentBy == .donee {
            requestObj = ["full_name":doneeFullnameTextField.text ?? "","email": doneeEmailTextField.text ?? "", "paypal_email": doneePaypalEmailTextField.text ?? "", "phone_number":doneePhoneNoTextField.text ?? "", "national_id": doneeNationalID.text ?? "","social_security_number": doneeSocialSecurityNoTextField.text ?? "", "occupation": doneeOccupationTextField.text ?? "", "password": doneePasswordTextField.text ?? "", "confirm_password": doneeConfirmPasswordTextField.text ?? "", "payment_method": "paypal","type": "\(sentBy.rawValue)"]
            phone = doneePhoneNoTextField.text ?? ""
            
        } else {
            requestObj = ["full_name":donorFullNameTextField.text ?? "","email": donorEmailTextField.text ?? "",  "phone_number":donorPhoneNoTextField.text ?? "", "occupation": donorOccupationTextField.text ?? "", "password": donorPasswordTextField.text ?? "", "confirm_password": donorConfirmPasswordTextField.text ?? "", "type": "\(sentBy.rawValue)"]
            phone = donorPhoneNoTextField.text ?? ""
        }
        
        apiRequestObject = requestObj
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) {[weak self] (verificationId, error) in
            Utility.hideLoading()
            
            if let error = error {
                self?.showAlert(title: "", message: error.localizedDescription )
                return
            }
            UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
            print("!!!! verification code sent successfully !!!!")
            let codeVerificationVC = CodeVerificationViewController()
            codeVerificationVC.sentBy = sentBy
            codeVerificationVC.verificationId = verificationId!
         //   codeVerificationVC.user = requestObj
            self?.navigationController?.pushViewController(codeVerificationVC, animated: true)
        }
    }
    
    private func checkDonorPasswordMatch () -> Bool {
        
        if donorPasswordTextField.text == donorConfirmPasswordTextField.text{
            donorPasswordController?.borderStrokeColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            donorConfirmPasswordController?.borderStrokeColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            donorPasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            donorConfirmPasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            return true
            
        } else{
            donorPasswordController?.borderStrokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            donorConfirmPasswordController?.borderStrokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            donorPasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            donorConfirmPasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            return false
        }
    }

    private func checkDoneePasswordsMatch () -> Bool {
        
        if doneePasswordTextField.text == doneeConfirmPasswordTextField.text{
            doneePasswordController?.borderStrokeColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            doneeConfirmPasswordController?.borderStrokeColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            doneePasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            doneeConfirmPasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
            return true
            
        } else{
            doneePasswordController?.borderStrokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            doneeConfirmPasswordController?.borderStrokeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            doneePasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            doneeConfirmPasswordController?.floatingPlaceholderNormalColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.504682149)
            return false
        }
    }
    
    private func settingAllTextFieldColors () {
        doneeFullnameController = MDCTextInputControllerOutlined(textInput: doneeFullnameTextField)
        doneeFullnameController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneeFullnameController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneeEmailController = MDCTextInputControllerOutlined(textInput: doneeEmailTextField)
        doneeEmailController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneeEmailController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneePaypalEmailController = MDCTextInputControllerOutlined(textInput: doneePaypalEmailTextField)
        doneePaypalEmailController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneePaypalEmailController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneePhoneNoController = MDCTextInputControllerOutlined(textInput: doneePhoneNoTextField)
        doneePhoneNoController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneePhoneNoController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneeNationalIdController = MDCTextInputControllerOutlined(textInput: doneeNationalID)
        doneeNationalIdController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneeNationalIdController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
    
        doneeSSNController = MDCTextInputControllerOutlined(textInput: doneeSocialSecurityNoTextField)
        doneeSSNController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneeSSNController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneeOccupationController = MDCTextInputControllerOutlined(textInput: doneeOccupationTextField)
        doneeOccupationController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneeOccupationController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneePasswordController = MDCTextInputControllerOutlined(textInput: doneePasswordTextField)
        doneePasswordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneePasswordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        doneeConfirmPasswordController = MDCTextInputControllerOutlined(textInput: doneeConfirmPasswordTextField)
        doneeConfirmPasswordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        doneeConfirmPasswordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        donorFullnameController = MDCTextInputControllerOutlined(textInput: donorFullNameTextField)
        donorFullnameController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        donorFullnameController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        donorEmailController = MDCTextInputControllerOutlined(textInput: donorEmailTextField)
        donorEmailController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        donorEmailController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        donorPhoneNoController = MDCTextInputControllerOutlined(textInput: donorPhoneNoTextField)
        donorPhoneNoController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        donorPhoneNoController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        donorOccupationController = MDCTextInputControllerOutlined(textInput: donorOccupationTextField)
        donorOccupationController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        donorOccupationController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        donorPasswordController = MDCTextInputControllerOutlined(textInput: donorPasswordTextField)
        donorPasswordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        donorPasswordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
        
        donorConfirmPasswordController = MDCTextInputControllerOutlined(textInput: donorConfirmPasswordTextField)
        donorConfirmPasswordController?.activeColor = #colorLiteral(red: 0.01176470588, green: 0.6549019608, blue: 0.8862745098, alpha: 0.8734749572)
        donorConfirmPasswordController?.floatingPlaceholderActiveColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6545911815)
    }
    
    private func settingTextFieldBorders () {
        doneeFullnameController?.borderRadius = 10.0
        doneeEmailController?.borderRadius = 10.0
        doneePaypalEmailController?.borderRadius = 10.0
        doneePhoneNoController?.borderRadius = 10.0
        doneeNationalIdController?.borderRadius = 10.0
        doneeSSNController?.borderRadius = 10.0
        doneeOccupationController?.borderRadius = 10.0
        doneePasswordController?.borderRadius = 10.0
        doneeConfirmPasswordController?.borderRadius = 10.0
        
        donorFullnameController?.borderRadius = 10.0
        donorEmailController?.borderRadius = 10.0
        donorPhoneNoController?.borderRadius = 10.0
        donorOccupationController?.borderRadius = 10.0
        donorPasswordController?.borderRadius = 10.0
        donorConfirmPasswordController?.borderRadius = 10.0
    }
    
    private func setUIForDonee () {
        self.doneeFullnameTextField.tag = 0
        self.doneeEmailTextField.tag = 1
        self.doneePaypalEmailTextField.tag = 2
        self.doneePhoneNoTextField.tag = 3
        self.doneeNationalID.tag = 4
        self.doneeSocialSecurityNoTextField.tag = 5
        self.doneeOccupationTextField.tag = 6
        self.doneePasswordTextField.tag = 7
        self.doneeConfirmPasswordTextField.tag = 8
        self.doneeFullnameTextField.delegate = self
        self.doneeEmailTextField.delegate = self
        self.doneePaypalEmailTextField.delegate = self
        self.doneePhoneNoTextField.delegate = self
        self.doneeNationalID.delegate = self
        self.doneeSocialSecurityNoTextField.delegate = self
        self.doneeOccupationTextField.delegate = self
        self.doneePasswordTextField.delegate = self
        self.doneeConfirmPasswordTextField.delegate = self
    }
    
    private func setUIForDonor () {
        self.donorFullNameTextField.tag = 0
        self.donorEmailTextField.tag = 1
        self.donorPhoneNoTextField.tag = 2
        self.donorOccupationTextField.tag = 3
        self.donorPasswordTextField.tag = 4
        self.donorConfirmPasswordTextField.tag = 5
        self.donorFullNameTextField.delegate = self
        self.donorEmailTextField.delegate = self
        self.donorPhoneNoTextField.delegate = self
        self.donorOccupationTextField.delegate = self
        self.donorPasswordTextField.delegate = self
        self.donorConfirmPasswordTextField.delegate = self
    }
    
    private func setDoneeState () {
        donorButton.setImage(#imageLiteral(resourceName: "ribbon_unselected"), for: .normal)
        doneeButton.setImage(#imageLiteral(resourceName: "selected_donee"), for: .normal)
        doneeSignupView.isHidden = false
        donorSignUpView.isHidden = true
        doneeButton.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        donorButton.backgroundColor = #colorLiteral(red: 0.9625374675, green: 0.9625598788, blue: 0.9625478387, alpha: 1)
        doneeButton.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        doneeButton.borderWidth = 0.1
        donorButton.borderWidth = 0.0
        doneeButton.setTitleColor(.black, for: .normal)
        donorButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }
    
    private func setDonorState () {
        doneeSignupView.isHidden = true
        donorSignUpView.isHidden = false
        donorButton.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        doneeButton.setImage(#imageLiteral(resourceName: "unselected_donee"), for: .normal)
        doneeButton.backgroundColor = #colorLiteral(red: 0.9625374675, green: 0.9625598788, blue: 0.9625478387, alpha: 1)
        donorButton.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        donorButton.borderColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        doneeButton.borderWidth = 0.0
        donorButton.borderWidth = 0.1
        donorButton.setTitleColor(.black, for: .normal)
        doneeButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }
    
    private func validateFields() -> Bool {
        
        if doneeSignupView.isHidden == false {
            
            if doneeFullnameTextField.text!.isEmpty ||
                doneeEmailTextField.text!.isEmpty ||
                doneePaypalEmailTextField.text!.isEmpty ||
                doneePhoneNoTextField.text!.isEmpty ||
                doneeNationalID.text!.isEmpty ||
                doneeSocialSecurityNoTextField.text!.isEmpty ||
                doneeOccupationTextField.text!.isEmpty ||
                doneePasswordTextField.text!.isEmpty {
                self.showAlert(title: "Error", message: "Please fill all the fields")
                return false
            }
            
            if !doneeEmailTextField.isValidEmail(doneeEmailTextField.text ?? "") {
                self.showAlert(title: "Error", message: "Email Id is incorrect")
                return false
            }
            
            if !doneePaypalEmailTextField.isValidEmail(doneePaypalEmailTextField.text ?? "") {
                self.showAlert(title: "Error", message: "Paypal email Id is incorrect")
                return false
            }
 
            if doneePasswordTextField.text?.count ?? 0 < 9 {
                self.showAlert(title: "Error", message: "Password should be greater than 8 characters.")
                return false
            }
            
            if doneePasswordTextField.text ?? "" != doneeConfirmPasswordTextField.text ?? ""{
                self.showAlert(title: "Error", message: "Password and confirm password does not match.")
                return false
            }
            
            return true
            
        } else if donorSignUpView.isHidden == false {
            
            if donorFullNameTextField.text!.isEmpty ||
                donorEmailTextField.text!.isEmpty ||
                donorPhoneNoTextField.text!.isEmpty ||
                donorOccupationTextField.text!.isEmpty ||
                donorPasswordTextField.text!.isEmpty {
                self.showAlert(title: "Error", message: "Please fill all the fields")
                return false
            }
            
            if !donorEmailTextField.isValidEmail(donorEmailTextField.text ?? "") {
                self.showAlert(title: "Error", message: "Email Id is incorrect")
                return false
            }
            
            if donorPasswordTextField.text?.count ?? 0 < 9 {
                self.showAlert(title: "Error", message: "Password should be greater than 8 characters.")
                return false
            }
            
            if donorPasswordTextField.text ?? "" != donorConfirmPasswordTextField.text ?? ""{
                self.showAlert(title: "Error", message: "Password and confirm password does not match.")
                return false
            }
            return true
        }
        return false
    }
}


