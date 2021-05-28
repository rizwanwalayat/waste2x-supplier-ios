//
//  NewWasteSizeViewController.swift
//  Waste2x
//
//  Created by MAC on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

protocol NewWasteSizeViewControllerDelegate {
    func detailSizeUpdated(_ updatedSize : String)
}

class NewWasteSizeViewController: BaseViewController {

    // MARK: - Outlet
    @IBOutlet weak var mainHolderview   : UIView!
    @IBOutlet weak var popupView        : UIView!
    @IBOutlet weak var sizeTextField    : UITextField!
    @IBOutlet weak var saveButton       : UIButton!
    @IBOutlet weak var newWasteSizeLabl : UILabel!
    @IBOutlet weak var backgroundButton : UIButton!
    
    // MARK: - Declarations
    
    var delegate             : NewWasteSizeViewControllerDelegate?
    var isNeedToCallDelegate = false
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popupView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
          self.popupView.transform = .identity
        })
    }

    func hidePopup()
    {
        popupView.alpha = 1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            
            self.popupView.alpha = 0
            self.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        }) { (success) in
            
            self.dismiss(animated: false, completion: nil)

        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if Utility.isTextFieldHasText(textField: sizeTextField) {
            hidePopup()
            delegate?.detailSizeUpdated(sizeTextField.text ?? "0")
        }
    }
    
    @IBAction func backgroundButtonPressed(_ sender : UIButton)
    {
        hidePopup()
    }
}
