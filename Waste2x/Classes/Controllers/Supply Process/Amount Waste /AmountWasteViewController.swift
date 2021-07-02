//
//  AmountWasteViewController.swift
//  Waste2x
//
//  Created by MAC on 08/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
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
    @IBOutlet weak var cancelButton: UIButton!
    
    
    // MARK: - Declarations
    
    var supplyProcessQuestions = [QuestionsSuppyProcess]()
    var tempArray = [QuestionsSuppyProcess]()
    var selectionData = [String: Any]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Global.shared.apiCurve ? (cancelButton.isHidden = false) : (cancelButton.isHidden = true)
        tempArray = supplyProcessQuestions
        
        
        numberOfTonsPerMonthLabel.text = tempArray.last?.title
        tempArray.removeLast()
        numberOfTonsTitleLabel.text = tempArray.last?.title
    }


    // MARK: - Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if checkFieldsAuth() {
            
            var questionsArray = selectionData["question_responses"] as! [String]
            let numberOftones = numberOfTonsTextField.text ?? ""
            let numberOftonesPerMonth = tonsPerMonthTextField.text ?? ""
            questionsArray.append(numberOftones)
            questionsArray.append(numberOftonesPerMonth)
            selectionData["question_responses"] = questionsArray
            
            guard let jsonStr = Utility.DictToJsonString(selectionData) else {
                Utility.showAlertController(self, "not converting dict to jsonString")
                return
                
            }
            var postDict = [String : Any]()
            if Global.shared.apiCurve{
                postDict = ["waste_selection_json" : jsonStr]
                
            }
            else {
                postDict = ["waste_type_questions" : jsonStr]
            }

            //let vc = WasteDetailLocationViewController(nibName: "WasteDetailLocationViewController", bundle: nil)
            let vc            = LocationPickerViewController(nibName: "LocationPickerViewController", bundle: nil)
            vc.isForSiteCreation = true
            vc.selectionData = postDict
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton)
    {
        Utility.homeViewController()
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
    
    func checkFieldsAuth() -> Bool
    {
        if !numberOfTonsTextField.text!.isEmpty && !tonsPerMonthTextField.text!.isEmpty{
            return true
        }
        Utility.showAlertController(self, "Please fill all fields")
        return false
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
