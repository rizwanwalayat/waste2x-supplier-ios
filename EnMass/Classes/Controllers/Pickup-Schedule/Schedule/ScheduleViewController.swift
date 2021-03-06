//
//  ScheduleViewController.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import GoogleMaps

enum SelectionType : String{
    case none
    case onePickup = "Only one pick-up"
    case regular = "Regular schedule"
}


class ScheduleViewController: BaseViewController {

    // MARK: - Local Enums
    
    
    enum PopupType {
        case none
        case site
        case frequency_preodic
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainHolderview: UIView!
    @IBOutlet weak var backgroundColoredView: UIView!
    
    @IBOutlet weak var onePickupHolderview: UIView!
    @IBOutlet weak var CheckboxonePickup: UIImageView!
    @IBOutlet weak var onePickupLabel: UILabel!
    @IBOutlet weak var onePickupButton: UIButton!
    
    @IBOutlet weak var regularPickupHolderview: UIView!
    @IBOutlet weak var checkboxRegular: UIImageView!
    @IBOutlet weak var regularPickupLabel: UILabel!
    @IBOutlet weak var regularPickupButton: UIButton!
    
    @IBOutlet weak var stackview : UIStackView!
    
    @IBOutlet weak var selectFrequencyPriodicHolderview: UIView!
    @IBOutlet weak var frequencyPriodicTitleLabel: UILabel!
    @IBOutlet weak var selectFrequencyPriodicContentview: UIView!
    @IBOutlet weak var selectFrequencyPriodicLabel: UILabel!
    @IBOutlet weak var selectFrequencyPriodicButton: UIButton!
    @IBOutlet weak var frequencyPeriodicImageview: UIImageView!
    
    
    @IBOutlet weak var selectSiteHolderview: UIView!
    @IBOutlet weak var siteTitleLabel: UILabel!
    @IBOutlet weak var selectSiteContentview: UIView!
    @IBOutlet weak var selectSiteLabel: UILabel!
    @IBOutlet weak var selectSiteButton: UIButton!
    @IBOutlet weak var siteImageview: UIImageView!
    
    @IBOutlet weak var selectDateTimeHolderview: UIView!
    @IBOutlet weak var DateTimeTitleLabel: UILabel!
    @IBOutlet weak var selectDateTimeContentview: UIView!
    @IBOutlet weak var selectDateTimeLabel: UILabel!
    @IBOutlet weak var selectDateTimeButton: UIButton!
    @IBOutlet weak var dateTimeImageview: UIImageView!
    
    @IBOutlet weak var selectLocationHolderview: UIView!
    @IBOutlet weak var LocationTitleLabel: UILabel!
    @IBOutlet weak var selectLocationContentview: UIView!
    @IBOutlet weak var selectLocationLabel: UILabel!
    @IBOutlet weak var selectLocationButton: UIButton!
    @IBOutlet weak var locationImageview: UIImageView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var notesHolderView: UIView!

    @IBOutlet weak var nextButton : UIButton!
    
    // MARK: - Declarations
    
    var selectionType = SelectionType.none
    var popupOptionType = PopupType.none
    let selectSitePlaceholder = "Select Site"
    let selectDateTimePlaceholder = "Select Date and Time"
    let selectLocationPlaceHolder = "Select Location"
    let selectFrequencyPerodicPlaceholder = "Select Frequency / Periodic"
    var locationAutoFill = false
    var sitesData = [FetchSitesCustomModel]()
    var tempFarmsData = [String : Int]()
    var postDictData = [String : Any]()
    var locationManager = CLLocationManager()
    var wasteDeatil : WasteDetialResult?
    var placeHolderText = "Type some details about your pickup ... "

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sitesData = FetchSitesDataModel.shared.sites()
//        globalObjectHome?.fetchSitesData[0].farmId
        selectionType = .onePickup
        pickupTypeHandlings(selectionType: selectionType)
        
        notesTextView.delegate = self
        
        //googleMapCurrentLocation()
        self.view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        backgroundColoredView.layer.cornerRadius = 36
        backgroundColoredView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        backgroundColoredView.layer.masksToBounds = true
        
        
    }
    
    fileprivate func returnSelectedDays() -> String
    {
        let selectedDaysCode = "MTWRF"
    
        return selectedDaysCode
    }
    
    // MARK: - Actions
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func nextButtonPressed(_ sender: UIButton)
    {
        if allFieldsAuth() {
            
            if selectionType == .onePickup {
                postDictData["frequency"] = "Daily"
            }
            
            postDictData["pick_up_note"] = notesTextView.text ?? ""
            postDictData["preferred_days"] = returnSelectedDays()
            postDictData["preferred_time"] = "Morning"
            postDictData["pick_up_date"] = selectDateTimeLabel.text ?? ""
            
            postDataFromServer()
            
            
//            let vc = ScheduleRegularViewController(nibName: "ScheduleRegularViewController", bundle: nil)
//            vc.selectedFrequency = selectFrequencyPriodicLabel.text ?? ""
//            vc.postDict = postDictData
//            vc.selectionType = selectionType
//            self.navigationController?.pushViewController(vc, animated: true)

            
//            postDictData["schedule_type"] = selectionType.rawValue
//            postDataFromServer()
        }
    }
    
    @IBAction func selectLocationButtonPressed(_ sender: Any) {
        
        if selectionType != .none {
//            showMapView()
            
        }
    }
    
    @IBAction func dateTimeButtonPressed(_ sender: Any) {
        
        if selectionType != .none {
            showCalenderView()
        }
    }
    
    @IBAction func frequencyPriodicButtonPressed(_ sender: Any) {
        
        if selectionType == .regular {
            popupOptionType = .frequency_preodic
            showPopupViewHandlings(forSelection: .frequency_preodic)
        }
    }
    
    @IBAction func selectSiteButtonPressed(_ sender: Any) {
        
        if selectionType != .none {
            popupOptionType = .site
            showPopupViewHandlings(forSelection: .site)
        }
    }
    
    @IBAction func regularScheduleButtonPressed(_ sender: Any) {
        
        (selectionType != .regular) ? (selectionType = .regular) : (selectionType = .none)
        pickupTypeHandlings(selectionType: selectionType)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any){
        Utility.homeViewController()
    }
    
    @IBAction func onePickupButtonPressed(_ sender: Any) {
        
//        (selectionType != .onePickup) ? (selectionType = .onePickup) : (selectionType = .none)
//        pickupTypeHandlings(selectionType: selectionType)
//        self.showToast(message: "TBD")
     
    }
    
    

}

// MARK: - UITextViewDelegate
extension ScheduleViewController: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(hexString: "2A2A2A")
            selectionHandlingsOfViews(notesHolderView, isSelection: true)
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
            selectionHandlingsOfViews(notesHolderView, isSelection: false)
        }
        else {
            
            selectionHandlingsOfViews(notesHolderView, isSelection: true)
        }
        
    }
}
