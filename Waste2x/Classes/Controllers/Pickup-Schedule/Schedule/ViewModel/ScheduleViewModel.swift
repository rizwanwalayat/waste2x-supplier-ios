//
//  ScheduleViewModel.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit

extension ScheduleViewController :  ScheduleOptionsViewControllerDelegate, CalenderPopupViewControllerDelegate, WasteDetailLocationViewControllerDelegate
{
    // MARK: - ScheduleOptionsViewControllerDelegate Method
    
    func didSelectOption(_ selectedOption: String) {
        
        print(selectedOption)
        if popupOptionType == .frequency_preodic
        {
            selectFrequencyPriodicLabel.text = selectedOption
            selectionHandlingsOfViews(selectFrequencyPriodicHolderview, isSelection: true)
        }
        else
        {
            selectSiteLabel.text = selectedOption
            selectionHandlingsOfViews(selectSiteHolderview, isSelection: true)
        }
        
        popupOptionType = .none
    }
    
    func didDismiss() {
        popupOptionType = .none
    }
    
    
    // MARK: - CalenderPopupViewControllerDelegate Method
    
    func didSelectDate(dateString: String)
    {
        selectDateTimeLabel.text = dateString
        selectionHandlingsOfViews(selectDateTimeHolderview, isSelection: true)
    }
    
    
    // MARK: - WasteDetailLocationViewControllerDelegate Method
    
    func selectedLocationDetail(address: String) {
        
        selectLocationLabel.text = address
        selectionHandlingsOfViews(selectLocationHolderview, isSelection: true)
    }
    
    // MARK: - Custom Methods Method
    
    func showPopupViewHandlings( forSelection : PopupType)
    {
        switch forSelection {
        
        case .frequency_preodic:
            
            var alreadySelectedText = ""
            (selectFrequencyPriodicLabel.text != selectFrequencyPerodicPlaceholder) ? (alreadySelectedText = selectFrequencyPriodicLabel.text ?? "") : (alreadySelectedText = "")
            
            let regularData = ["Daily", "Weekly", "Monthly"]
            let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
            optionsCustompopup.modalPresentationStyle = .overFullScreen
            optionsCustompopup.delegate = self
            optionsCustompopup.optionsData = regularData
            optionsCustompopup.alreadySelectedString = alreadySelectedText
            self.present(optionsCustompopup, animated: false, completion: nil)
            
        case .site:
            
            var alreadySelectedText = ""
            (selectSiteLabel.text != selectSitePlaceholder) ? (alreadySelectedText = selectSiteLabel.text ?? "") : (alreadySelectedText = "")
            
            let siteData = ["Cattle (Site 1)", "Factory (Site 2)", "Tire Dealer (Site 3)"]
            let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
            optionsCustompopup.modalPresentationStyle = .overFullScreen
            optionsCustompopup.delegate = self
            optionsCustompopup.optionsData = siteData
            optionsCustompopup.alreadySelectedString = alreadySelectedText
            self.present(optionsCustompopup, animated: false, completion: nil)
        
        case .none:
            
            print("Nothing")
            // nothing
        
        }
    }
    
    func showCalenderView()
    {
        var alreadySelectedText = ""
        (selectDateTimeLabel.text != selectDateTimePlaceholder) ? (alreadySelectedText = selectDateTimeLabel.text ?? "") : (alreadySelectedText = "")
        
        let calenderVC               = CalenderPopupViewController(nibName: "CalenderPopupViewController", bundle: nil)
        calenderVC.modalPresentationStyle = .overFullScreen
        calenderVC.delegate = self
        calenderVC.alreadySelectedDateTime = alreadySelectedText
        self.present(calenderVC, animated: false, completion: nil)
    }
    
    func showMapView()
    {
        let locationVC            = WasteDetailLocationViewController(nibName: "WasteDetailLocationViewController", bundle: nil)
        locationVC.delegate       = self
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    func pickupTypeHandlings(selectionType : SelectionType)
    {
        selectSiteLabel.text = selectSitePlaceholder
        selectFrequencyPriodicLabel.text = selectFrequencyPerodicPlaceholder
        selectDateTimeLabel.text = selectDateTimePlaceholder
        self.locationAutoFill ? print("Nothing") : (selectLocationLabel.text = selectLocationPlaceHolder)
        selectionHandlingsOfViews(selectSiteHolderview, isSelection: false)
        selectionHandlingsOfViews(selectFrequencyPriodicHolderview, isSelection: false)
        selectionHandlingsOfViews(selectDateTimeHolderview, isSelection: false)
        self.locationAutoFill ? print("Nothing") : selectionHandlingsOfViews(selectLocationHolderview, isSelection: false)
        
        let lableUnselectHexCode = "A09F9F"
        let lableSelectedHexCode = "2B2B2B"
        
        switch selectionType {
        
        case .onePickup:
            
            self.regularPickupHolderview.animateBorderColor(toColor: UIColor.clear, duration: 0.1)
            self.regularPickupHolderview.borderWidth = 0
            self.checkboxRegular.backgroundColor = UIColor.clear
            self.checkboxRegular.image = UIImage(named: "")
            self.regularPickupLabel.textColor = UIColor(hexString: lableUnselectHexCode)
            
            self.onePickupHolderview.borderWidth = 1
            self.onePickupHolderview.animateBorderColor(toColor: UIColor.appColor, duration: 0.3)
            self.CheckboxonePickup.backgroundColor = UIColor.appColor
            self.CheckboxonePickup.image = UIImage(named: "check")
            self.onePickupLabel.textColor = UIColor(hexString: lableSelectedHexCode)
            hideAnimated(in: stackview, selectFrequencyPriodicHolderview, selectDateTimeHolderview)
    
        case .regular:
            
            self.onePickupHolderview.animateBorderColor(toColor: UIColor.clear, duration: 0.1)
            self.onePickupHolderview.borderWidth = 0
            self.CheckboxonePickup.backgroundColor = UIColor.clear
            self.CheckboxonePickup.image = UIImage(named: "")
            self.onePickupLabel.textColor = UIColor(hexString: lableUnselectHexCode)
            
            self.regularPickupHolderview.borderWidth = 1
            self.regularPickupHolderview.animateBorderColor(toColor: UIColor.appColor, duration: 0.3)
            self.checkboxRegular.backgroundColor = UIColor.appColor
            self.checkboxRegular.image = UIImage(named: "check")
            self.regularPickupLabel.textColor = UIColor(hexString: lableSelectedHexCode)
            //hideAnimated(in: stackview, selectDateTimeHolderview, selectFrequencyPriodicHolderview)
            showAnimated(in: stackview, selectFrequencyPriodicHolderview)
            
        case .none:
            
            self.regularPickupHolderview.animateBorderColor(toColor: UIColor.clear, duration: 0.1)
            self.regularPickupHolderview.borderWidth = 0
            self.regularPickupLabel.textColor = UIColor(hexString: lableUnselectHexCode)
            self.checkboxRegular.backgroundColor = UIColor.clear
            self.checkboxRegular.image = UIImage(named: "")
            
            self.onePickupHolderview.borderWidth = 0
            self.onePickupHolderview.animateBorderColor(toColor: UIColor.clear, duration: 0.3)
            self.onePickupLabel.textColor = UIColor(hexString: lableUnselectHexCode)
            self.CheckboxonePickup.backgroundColor = UIColor.clear
            self.CheckboxonePickup.image = UIImage(named: "")
            //hideAnimated(in: stackview, selectFrequencyPriodicHolderview, selectDateTimeHolderview)
            showAnimated(in: stackview, selectFrequencyPriodicHolderview)
            showAnimated(in: stackview, selectDateTimeHolderview)
        }
    }
    
    fileprivate func hideAnimated(in stackView: UIStackView, _ ofView : UIView, _ hideView: UIView) {
        if !ofView.isHidden {
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: [.curveEaseOut],
                animations: {
                    ofView.isHidden = true
                    ofView.alpha = 0.0
                    stackView.layoutIfNeeded()
                },
                completion: { complete in
                    self.showAnimated(in: self.stackview, hideView)
                })
        }
    }
    
    fileprivate func showAnimated(in stackView: UIStackView, _ ofView : UIView) {
        if ofView.isHidden {
            UIView.animate(
                withDuration: 0.3,
                delay: 0.0,
                options: [.curveEaseOut],
                animations: {
                    ofView.isHidden = false
                    ofView.alpha = 1.0
                    stackView.layoutIfNeeded()
                })
        }
    }
    
    func selectionHandlingsOfViews(_ holderView : UIView, isSelection : Bool)
    {
        let selectedBodyLabelTextColor = "2A2A2A"
        let unSelectedBodyLabelTextColor = "A09F9F"
        
        let selectedTitleLabelTextColor = "5F5F5F"
        let unSelectedTitleLabelTextColor = unSelectedBodyLabelTextColor
        
        let selectedBackground = "FFFFFF"
        let unSelectedBackground = "D8D8D8"
        
        
        for view in holderView.subviews
        {
            if let textLabel = view as? UILabel
            {
                textLabel.textColor = isSelection ? UIColor(hexString: selectedTitleLabelTextColor) : UIColor(hexString: unSelectedTitleLabelTextColor)
            }
            else
            {
                for subView in view.subviews
                {
                    if let bodyLabel = subView as? UILabel
                    {
                        bodyLabel.textColor = isSelection ? UIColor(hexString: selectedBodyLabelTextColor) : UIColor(hexString: unSelectedBodyLabelTextColor)
                    }
                    
                    if let imageView = subView as? UIImageView
                    {
                        imageView.tintColor = isSelection ? UIColor.appColor : UIColor(hexString: unSelectedBodyLabelTextColor)
                    }
                }
                
                if isSelection{
                    view.borderWidth = 1
                    view.animateBorderColor(toColor: UIColor.appColor, duration: 0.1)
                    view.backgroundColor = UIColor(hexString: selectedBackground)
                }
                else {
                    view.animateBorderColor(toColor: UIColor.appColor, duration: 0.1)
                    view.borderWidth = 0
                    view.backgroundColor = UIColor(hexString: unSelectedBackground)
                }
            }
        }
    }
    
    func allFieldsAuth() -> Bool
    {
        switch selectionType {
        
        case .none:
            return false
        case .regular:
            
            if selectFrequencyPriodicLabel.text != selectFrequencyPerodicPlaceholder && selectSiteLabel.text != selectSitePlaceholder && selectDateTimeLabel.text != selectDateTimePlaceholder && selectLocationLabel.text != selectLocationPlaceHolder
            {
                return true
            }
            return false
        case .onePickup:
            
            if selectSiteLabel.text != selectSitePlaceholder && selectDateTimeLabel.text != selectDateTimePlaceholder && selectLocationLabel.text != selectLocationPlaceHolder
            {
                return true
            }
            return false
        }
    }
}


