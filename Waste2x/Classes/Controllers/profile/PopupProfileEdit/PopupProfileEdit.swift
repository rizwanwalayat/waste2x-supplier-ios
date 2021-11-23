//
//  CreateAnOtherLoadViewController.swift
//  CarrierApp
//
//  Created by MAC on 16/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class PopupProfileEdit: BaseViewController {

    enum ButtonSelectedStates {
        case cancel
        case save
        case none
    }
    // MARK: - Outlets
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var mainContentView: UIView!
    
    var iAmAllDoneButtonPressed: (()->())?
    var changedUserName: (()->())?
    var viewModel: ProfileEditVM?

    // MARK: - Controller's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainContentView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        self.userName.text = viewModel?.userName ?? ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
          self.mainContentView.transform = .identity
        })
    }
    
    
    func hidePopup(_ buttonState : ButtonSelectedStates)
    {
        mainContentView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.mainContentView.alpha = 0
            self.mainContentView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        }) { (success) in
            
            switch buttonState {
            case .save:
                
                self.changedUserName?()
                
            case .cancel:
                
                self.iAmAllDoneButtonPressed?()
                
            case .none:
                
                print("nothing pressed")
            }
            
            self.dismiss(animated: false, completion: nil)
        }
    }

    @IBAction func backButton(_ sender: Any) {
        
        hidePopup(.none)
        
    }
    @IBAction func cancelBtnPressed(_ sender: Any) {
    
        hidePopup(.cancel)
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        viewModel?.editUserName(newName: userName.text ?? viewModel?.userName ?? "", { result, error, status, message in
            if status ?? false, error == nil {
                self.showToast(message: message)
                self.hidePopup(.save)
                if let resultString = result?.result?.toJSONString() {
                    
                    DataManager.shared.saveUsersDetail(resultString)
                }
            } else {
                self.showToast(message: error?.localizedDescription ?? message)
            }
        })
    }

}
