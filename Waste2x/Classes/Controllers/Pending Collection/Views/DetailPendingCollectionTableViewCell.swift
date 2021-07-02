//
//  DetailPendingCollectionTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 23/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import StepIndicator
class DetailPendingCollectionTableViewCell: BaseTableViewCell {
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
    
    @IBOutlet weak var hiddenView: UIView!
    
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
    func confirmConfig(data:PendingCollectionResultResponce){
        
        self.farmLabel.text = data.farm
        if data.frequency == "" {
            self.scheduleLabel.text = data.schedule_type
        }
        
        else{
            self.scheduleLabel.text = data.schedule_type + " (\(data.frequency))"
            
        }
        self.dateLabel.text = data.scheduleDate
        self.addressLabel.text = data.address
        
        //MARK: - Stepper

        self.hiddenView.isHidden = true
        if data.history.count > 0 {
            self.hiddenView.isHidden = false
            if  data.history.count == 1 && data.history[0].status == "Pending"{
                
                self.activityDate1.text = data.history[0].activityDate
                self.stepperView.currentStep = 0
            }
            
            else if data.history.count == 2 && data.history[1].status == "Confirmed"{
                self.activityDate2.text = data.history[1].activityDate
                self.stepperView.currentStep = 1
            }
            else if data.history.count == 3 && data.history[2].status == "Picked"{
                self.activityDate3.text = data.history[2].activityDate
                self.stepperView.currentStep = 2
            }
            else if data.history.count == 4 && data.history[2].status == "Delivered"{
                self.activityDate4.text = data.history[3].activityDate
                self.stepperView.currentStep = 3
            }
        }
        
    }
    func expandCollapseView(index:Int) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()}, completion: { finished in
                print("Expand \(index)")
        })
    }

        
        
    
    
}
