//
//  LoginInputEmailViewController.swift
//  Waste2x
//
//  Created by MAC on 24/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class LoginInputEmailViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var enterYourEmailLabel: UILabel!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.makeEnable(value: false)
    }


    // MARK: - Actions

    @IBAction func nextButtonPressed(_ sender: Any) {
        Registration.emailVerification(email: self.emailAddressTextField.text!) { result, error, status,message in
            if status == 200 && DataManager.shared.getUser()?.result?.isNewUser == false {
                
                
            let slider = SlideMenuController(mainViewController: ContainerViewController(), leftMenuViewController: SideMenuViewController())
                self.navigationController?.setViewControllers([slider], animated: true)
            }
            else{
                let vc = SupplyingTypeViewController(nibName: "SupplyingTypeViewController", bundle: nil)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - TextField Delegate Methods

extension LoginInputEmailViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if Utility.isValidEmail(emailStr: textField.text ?? "") {
            nextButton.makeEnable(value: true)
        }
        else
        {
            nextButton.makeEnable(value: false)
        }
        
        return true
    }
}
