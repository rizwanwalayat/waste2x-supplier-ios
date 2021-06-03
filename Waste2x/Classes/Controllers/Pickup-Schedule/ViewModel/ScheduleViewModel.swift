//
//  ScheduleViewModel.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit

extension ScheduleViewController : UITableViewDelegate, UITableViewDataSource, ScheduleOptionsViewControllerDelegate
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "SchedulesTableViewCell", for: indexPath) as! SchedulesTableViewCell
        
        switch indexPath.row {
        
        
        case 0:
            
            cell.UIAdjustment(cellType: .onePickup, (selectionType == .onePickup) ? true : false, bodyLabelText: nil)
            
            
        case 1:
            
            cell.UIAdjustment(cellType: .regularSchedule, (selectionType == .regular) ? true : false, bodyLabelText: nil)
            
            
        case 2:
            
            let FrequencyAndPeriodicText = filedsData[.FrequencyAndPeriodic]
            let siteText = filedsData[.site]
            (selectionType == .regular) ? (cell.UIAdjustment(cellType: .FrequencyAndPeriodic, false, bodyLabelText: FrequencyAndPeriodicText)) : (cell.UIAdjustment(cellType: .site, false, bodyLabelText: siteText))
            
        case 3:
            
            let FrequencyAndPeriodicText = filedsData[.FrequencyAndPeriodic]
            let siteText = filedsData[.site]
            (selectionType == .regular) ? (cell.UIAdjustment(cellType: .site, false)) : (cell.UIAdjustment(cellType: .dateAndTime, false))
            
        default:
            
            cell.UIAdjustment(cellType: .location, false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            (selectionType == .onePickup) ? (selectionType = .none) : (selectionType = .onePickup)
            
        case 1:
            
            (selectionType == .regular) ? (selectionType = .none) : (selectionType = .regular)
            
        case 2:
            
            if let cell = tableview.cellForRow(at: indexPath) as? SchedulesTableViewCell
            {
                showPopupViewHandlings(forSection: 2, alreadySelectedString: cell.bodyTitleLabel.text ?? "")
                
            }
            
        case 3:
            
            if let cell = tableview.cellForRow(at: indexPath) as? SchedulesTableViewCell
            {
                showPopupViewHandlings(forSection: 3, alreadySelectedString: cell.bodyTitleLabel.text ?? "")
                
            }
            
            
        default:
            
            print("Nothing select")
        }
        
        
        self.tableview.reloadData()
    }
    
    
    func showPopupViewHandlings( forSection : Int, alreadySelectedString : String)
    {
     
        if selectionType != .none
        {
            if forSection == 2
            {
                let regularData = ["Daily, Weekly, Monthly"]
                let siteData = ["Cattle (Site 1)", "Factory (Site 2)", "Tire Dealer (Site 3)"]
                let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
                optionsCustompopup.modalPresentationStyle = .overFullScreen
                optionsCustompopup.delegate = self
                
                (selectionType == .regular) ? (optionsCustompopup.optionsData = regularData) : (optionsCustompopup.optionsData = siteData)
                optionsCustompopup.alreadySelectedString = alreadySelectedString
                self.present(optionsCustompopup, animated: false, completion: nil)
            }
            
            if forSection == 3
            {
                if selectionType == .regular
                {
                    let siteData = ["Cattle (Site 1)", "Factory (Site 2)", "Tire Dealer (Site 3)"]
                    let optionsCustompopup               = ScheduleOptionsViewController(nibName: "ScheduleOptionsViewController", bundle: nil)
                    optionsCustompopup.modalPresentationStyle = .overFullScreen
                    optionsCustompopup.delegate = self
                    optionsCustompopup.optionsData = siteData
                    optionsCustompopup.alreadySelectedString = alreadySelectedString
                    self.present(optionsCustompopup, animated: false, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: - ScheduleOptionsViewControllerDelegate Method
    func didSelectOption(_ selectedOption: String) {
        
        print(selectedOption)
    }
}
