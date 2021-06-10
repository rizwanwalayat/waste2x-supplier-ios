//
//  AmountWasteViewController.swift
//  Waste2x
//
//  Created by MAC on 08/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import StepIndicator

class AmountWasteViewController: BaseViewController {
    

    // MARK: - Outlets
    
    @IBOutlet weak var setpsIndicatorView: StepIndicatorView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var formLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var numberOfTonsHolderView: UIView!
    @IBOutlet weak var numberOfTonsTextField: UITextField!
    @IBOutlet weak var NumberOfTonsFieldHolderView: UIView!
    @IBOutlet weak var numberOfTonsTitleLabel: UILabel!
    @IBOutlet weak var tonsLabel: UILabel!
    @IBOutlet weak var tonsPerMonthHolderView: UIView!
    @IBOutlet weak var numberOfTonsPerMonthLabel: UILabel!
    @IBOutlet weak var tonsPerMonthTextField: UITextField!
    @IBOutlet weak var numberOfTonsPerMonthFieldHolderView: UIView!
    @IBOutlet weak var tons_MonthsLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let vc = WasteDetailLocationViewController(nibName: "WasteDetailLocationViewController", bundle: nil)
        vc.isForSiteCreation = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - TextFeild Delegate

extension AmountWasteViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == numberOfTonsTextField
        {
            self.selectionHandlingsOfViews(NumberOfTonsFieldHolderView, isSelection: true)
        }
        else
        {
            self.selectionHandlingsOfViews(numberOfTonsPerMonthFieldHolderView, isSelection: true)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 8
        {
            return false
            
        }
       return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == numberOfTonsTextField
        {
            let isSelected = textField.text!.isEmpty ? false : true
            self.selectionHandlingsOfViews(NumberOfTonsFieldHolderView, isSelection: isSelected)
        }
        else
        {
            let isSelected = textField.text!.isEmpty ? false : true
            self.selectionHandlingsOfViews(numberOfTonsPerMonthFieldHolderView, isSelection: isSelected)
        }
    }
}

// MARK: - Custom Methods

extension AmountWasteViewController
{
    func selectionHandlingsOfViews(_ holderView : UIView, isSelection : Bool)
    {
        let unSelectedBorder = "CFDAD5"
        
        holderView.borderWidth = 1
        
        let color = isSelection ? UIColor.appColor : UIColor(hexString: unSelectedBorder)
        holderView.animateBorderColor(toColor: color, duration: 0.1)
    }
}
