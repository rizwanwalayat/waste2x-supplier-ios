//
//  ScheduleRegularViewController.swift
//  Waste2x
//
//  Created by MAC on 06/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class ScheduleRegularViewController: BaseViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var availableDaysView: UIView!
    @IBOutlet weak var collectionViewAvailableDays: UICollectionView!
    @IBOutlet weak var availableTimeHolderView: UIView!
    @IBOutlet weak var availableTImeValueLabel: UILabel!
    @IBOutlet weak var dateHolderView: UIView!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var notesHolderView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var mainRoundedView: UIView!
    
    // MARK: - Outlets
    
    var weekDaysArray = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var selectedWeeksArray = [Int]()
    var placeHolderText = "Type some details about your pickup ... "
    var selectedFrequency = ""
    var postDict = [String : Any]()
    var dateValuePlaceHolder = "Select Date"
    var selectionType = SelectionType.regular
    
    // MARK: - Controller's Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialUiHandlings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainRoundedView.layer.cornerRadius = 36
        mainRoundedView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
        mainRoundedView.layer.masksToBounds = true
    }
    
    // MARK: - Custom Methods
    private func initialUiHandlings()
    {
        // collection view register nib
        collectionViewAvailableDays.register(UINib(nibName: "DaysNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DaysNameCollectionViewCell")
        
        // TextView placeholder handlings
        notesTextView.text = placeHolderText
        notesTextView.textColor = UIColor.lightGray
        
        // defualt moring selected 
        availableTImeValueLabel.text = "Morning"
        selectionHandlingsOfViews(availableTimeHolderView, isSelection: true)
        
        // weeksHandlings
        
        if selectedFrequency == "Daily" || selectionType == .onePickup{
            availableDaysView.isHidden = true
            selectedWeeksArray = [0, 1, 2, 3, 4, 5]
        }
        
        // set dateValue placeHolder
        dateValueLabel.text = dateValuePlaceHolder
        
        if selectionType == .onePickup
        {
            availableDaysView.isHidden = true
        }
    }

    
    func showPopupViewHandlings()
    {
        let regularData = ["Morning", "Evening"]
        
        let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
        optionsCustompopup.modalPresentationStyle = .overFullScreen
        optionsCustompopup.delegate = self
        optionsCustompopup.optionsData = regularData
        optionsCustompopup.alreadySelectedString = availableTImeValueLabel.text ?? ""
        self.present(optionsCustompopup, animated: false, completion: nil)
    }
    
    func showCalenderView()
    {
        let calenderVC               = CalenderPopupViewController(nibName: "CalenderPopupViewController", bundle: nil)
        calenderVC.modalPresentationStyle = .overFullScreen
        calenderVC.delegate = self
        calenderVC.alreadySelectedDateTime = dateValueLabel.text ?? ""
        self.present(calenderVC, animated: false, completion: nil)
    }
    
    fileprivate func selectionHandlingsOfViews(_ holderView : UIView, isSelection : Bool)
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
                        imageView.tintColor = isSelection ? UIColor.icons : UIColor(hexString: unSelectedBodyLabelTextColor)
                    }
                }
                
                if isSelection{
                    view.borderWidth = 1
                    view.animateBorderColor(toColor: UIColor.lineColor, duration: 0.1)
                    view.backgroundColor = UIColor(hexString: selectedBackground)
                }
                else {
                    view.animateBorderColor(toColor: UIColor.lineColor, duration: 0.1)
                    view.borderWidth = 0
                    view.backgroundColor = UIColor(hexString: unSelectedBackground)
                }
            }
        }
    }
    
    fileprivate func returnSelectedDays() -> String
    {
        var selectedDaysCode = ""
        for index in selectedWeeksArray {
            
            let day = weekDaysArray[index]
            selectedDaysCode.append("\(day) ")
        }
        
        return selectedDaysCode.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    
    fileprivate func checkAllFieldsAuth() -> Bool
    {
        switch selectionType {
        case .onePickup:
            
            if dateValueLabel.text == dateValuePlaceHolder {
                Utility.showAlertController(self, "Please Select Preferred Start Date")
                return false
            }
            
        case .regular:
            
            if selectedWeeksArray.count <= 0 {
                Utility.showAlertController(self, "Please Choose Day(s)")
                return false
            }
            
            if dateValueLabel.text == dateValuePlaceHolder {
                Utility.showAlertController(self, "Please Select Preferred Start Date")
                return false
            }
        case .none:
                
            return false
                
        }
        
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func availableTimeButtonPressed(_ sender: Any) {
        
        showPopupViewHandlings()
    }
    
    @IBAction func selectDateButtonPressed(_ sender: Any) {
        
        showCalenderView()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        let notesText = notesTextView.text ?? ""
        postDict["pick_up_note"] = notesText
        
        let selectedDaysCode = returnSelectedDays()
        postDict["preferred_days"] = selectedDaysCode
        
        if checkAllFieldsAuth() {
            
            postDataFromServer()
        }
    }
}


// MARK: - CollectionView Delegate & DataSource
extension ScheduleRegularViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        weekDaysArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DaysNameCollectionViewCell", for: indexPath) as! DaysNameCollectionViewCell
        
        cell.daysValueLabel.text = weekDaysArray[indexPath.item]
        
        if selectedWeeksArray.contains(indexPath.item)
        {
            cell.selectedItems()
        }
        else
        {
            cell.unSelectedItems()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedWeeksArray.contains(indexPath.item){
            
            if let index = selectedWeeksArray.firstIndex(of: indexPath.item) {
                selectedWeeksArray.remove(at: index)
            }
        }
        else
        {
            selectedWeeksArray.append(indexPath.item)
        }
        
        collectionViewAvailableDays.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionViewAvailableDays.bounds.width / 2) - 9 // 9 is difference between cells
        return CGSize(width: width, height: 40)
    }
    
    
}


// MARK: - ScheduleOptionsViewControllerDelegate
extension ScheduleRegularViewController: ScheduleOptionsViewControllerDelegate
{
    func didSelectOption(_ selectedOption: String) {
        
        availableTImeValueLabel.text = selectedOption
        selectionHandlingsOfViews(availableTimeHolderView, isSelection: true)
        postDict["preferred_time"] = selectedOption
    }
    
    func didDismiss() {
        
    }
}


// MARK: - CalenderPopupViewControllerDelegate
extension ScheduleRegularViewController: CalenderPopupViewControllerDelegate
{
    func didSelectDateString(dateString: String) {
        
        dateValueLabel.text = dateString
        selectionHandlingsOfViews(dateHolderView, isSelection: true)
        
        postDict["pick_up_date"] = dateString
        
//        let selectedDate = stringToDate(dateString)
//        let selecteDateString = selectedDate?.dateToString("YYYY:MM:DD HH:mm") ?? ""
    }
    
    func stringToDate(_ dateStr : String) -> Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy - hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = TimeZone.current

        guard let dateObj = dateFormatter.date(from: dateStr) else {return nil}
        return dateObj
    }
}


// MARK: - UITextViewDelegate
extension ScheduleRegularViewController: UITextViewDelegate
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


// MARK: - API Calling
extension ScheduleRegularViewController {
    
    fileprivate func postDataFromServer()
    {
        
        let postDict = postDict as [String : AnyObject]
        
        PickupScheduleDataModel.postPickupScheduleData(params: postDict) { response, error, success,message  in
            
            if error != nil
            {
                Utility.showAlertController(self, message)
            }
            
            if let isSuccess = success  {
                
                if isSuccess {
                    
                    let vc = SchedulePlannedViewController(nibName: "SchedulePlannedViewController", bundle: nil)
                    vc.result = response?.result
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else
                {
                    Utility.showAlertController(self, message)
                }
            }
            else
            {
                Utility.showAlertController(self, message)
            }
        }
    }
}
