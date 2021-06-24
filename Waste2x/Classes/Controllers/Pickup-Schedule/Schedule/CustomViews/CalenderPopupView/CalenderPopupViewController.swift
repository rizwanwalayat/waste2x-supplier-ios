//
//  CalenderPopupViewController.swift
//  Waste2x
//
//  Created by MAC on 03/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import FSCalendar

protocol CalenderPopupViewControllerDelegate {
    
    func didSelectDate( dateString : String)
}
class CalenderPopupViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var calenderview: FSCalendar!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    
    // MARK: - Declarations
    
    var timesSchadules = ["12:00 AM", "01:00 AM", "02:00 AM", "03:00 AM", "04:00 AM", "05:00 AM", "06:00 AM", "07:00 AM", "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM", "09:00 PM", "10:00 PM", "11:00 PM"]
    var delegate : CalenderPopupViewControllerDelegate?
    var alreadySelectedDateTime = ""
    var lastSelectedDate = Date()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.popupView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        timeLabel.text = timesSchadules[0]
        
        calenderview.delegate = self
        alreadySelectedDateTimeHandlings()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [],  animations: {
            
          self.popupView.transform = .identity
        })
    }
    
    func alreadySelectedDateTimeHandlings()
    {
        let stringArray = alreadySelectedDateTime.components(separatedBy: "-")
        guard let dateString = stringArray.first else {return }
        guard let date = dateString.stringToDate("MMM dd, yyyy") else {return }
        calenderview.select(date, scrollToDate: true)
        
        guard let timeSting = stringArray.last else {return }
        let trimmedString = timeSting.trimmingCharacters(in: .whitespaces)
        if timesSchadules.contains(trimmedString) {
            timeLabel.text = trimmedString
        }
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
    @IBAction func upButtonPressed(_ sender: Any) {
        
//        let indexArray = timesSchadules.indexes(of: timeLabel.text ?? "")
//        let index = (indexArray.first ?? 0) + 1
//
//        if index < timesSchadules.count
//        {
//            timeLabel.text = timesSchadules[index]
//        }
    
        
        let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
        optionsCustompopup.modalPresentationStyle = .overFullScreen
        optionsCustompopup.delegate = self
        optionsCustompopup.optionsData = timesSchadules
        optionsCustompopup.alreadySelectedString = timeLabel.text ?? ""
        self.present(optionsCustompopup, animated: false, completion: nil)
    }
    
    @IBAction func downButtonPressed(_ sender: Any) {
        
        let indexArray = timesSchadules.indexes(of: timeLabel.text ?? "")
        let index = (indexArray.first ?? 0) - 1
        
        if index >= 0
        {
            timeLabel.text = timesSchadules[index]
        }
    }
    
    @IBAction func backgroundButtonPressed(_ sender : UIButton)
    {
        hidePopup()
    }
    
    @IBAction func reverseButtonPressed(_ sender : UIButton)
    {
        let date = lastSelectedDate.startOfDay
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: date)
        lastSelectedDate = previousMonth ?? date
        calenderview.select(previousMonth, scrollToDate: true)
    }
    
    @IBAction func forwardButtonPressed(_ sender : UIButton)
    {
        let date = lastSelectedDate.startOfDay
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date)
        lastSelectedDate = nextMonth ?? date
        calenderview.select(nextMonth, scrollToDate: true)
    }
}


extension CalenderPopupViewController : FSCalendarDelegate
{
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        return true
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateString = date.dateToString("MMM dd, yyyy")
        print(dateString)
        
        let selectedString = "\(dateString) - \(timeLabel.text ?? "")"
        hidePopup()
        delegate?.didSelectDate(dateString: selectedString)
    }
}

extension CalenderPopupViewController : ScheduleOptionsViewControllerDelegate
{
    func didSelectOption(_ selectedOption: String) {
        
        timeLabel.text = selectedOption
    }
    
    func didDismiss() {
        
        print("dismiss")
    }
    
    
}
