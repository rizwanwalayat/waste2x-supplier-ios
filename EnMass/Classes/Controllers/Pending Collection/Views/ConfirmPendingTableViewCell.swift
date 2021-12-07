//
//  PendingTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import StepIndicator
class ConfirmPendingTableViewCell: UITableViewCell {

    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet var daysLabel : [UIView]!
    @IBOutlet weak var farmLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var stepperView: StepIndicatorView!
    @IBOutlet weak var activityDate1: UILabel!
    @IBOutlet weak var activityDate2: UILabel!
    @IBOutlet weak var activityDate3: UILabel!
    @IBOutlet weak var activityDate4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hiddenView.isHidden = true
        for dayLbl in daysLabel
        {
            dayLbl.sizeToFit()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK: - Functions
    func confirmConfig(data:PendingCollectionDataModel){
        if data.history.count > 0{
            
        }
        
        self.farmLabel.text = data.farm
        
        if data.schedule_type == ""
        {
            self.scheduleLabel.text = "Regular Schedule (Daily)"
        }
        else if data.frequency == "" {
            self.scheduleLabel.text = data.schedule_type
        }
        else{
            self.scheduleLabel.text = data.schedule_type + " (\(data.frequency))"
            
        }
        self.dateLabel.text = data.schedule_date
        self.addressLabel.text = data.address
        //MARK: - Stepper

        
        for (indexNew, _) in data.history.enumerated() {
            
            if data.history[indexNew].status == "Pending"{
                
                self.activityDate1.text = data.history[indexNew].activityDate
                self.stepperView.currentStep = 0
            }
            
            else if data.history[indexNew].status == "Confirmed"{
                self.activityDate2.text = data.history[indexNew].activityDate
                self.stepperView.currentStep = 1
            }
            else if data.history[indexNew].status == "Picked"{
                self.activityDate3.text = data.history[indexNew].activityDate
                self.stepperView.currentStep = 2
            }
            else {
                self.activityDate4.text = data.history[indexNew].activityDate
                self.stepperView.currentStep = 3
            }
        }
        
    }
    func expandCollapseView(index:Int) {
        self.hiddenView.isHidden = !self.hiddenView.isHidden
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
                print("Expand \(index)")
        })
    }

}
