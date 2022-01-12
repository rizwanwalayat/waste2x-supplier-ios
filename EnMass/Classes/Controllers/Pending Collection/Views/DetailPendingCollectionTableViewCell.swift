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
    func confirmConfig(data:PendingCollectionDataModel){
        
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

        self.hiddenView.isHidden = true
        if data.history.count > 0 {
            self.hiddenView.isHidden = false
            if  data.history.count > 0{
                
                self.activityDate1.text = data.history[0].activityDate
                self.stepperView.currentStep = 1
            }
            
            if data.history.count > 1 {
                self.activityDate2.text = data.history[1].activityDate
                self.stepperView.currentStep = 2
            }
            if data.history.count > 2 {
                self.activityDate3.text = data.history[2].activityDate
                self.stepperView.currentStep = 3
            }
            if data.history.count > 3 {
                self.activityDate4.text = data.history[3].activityDate
                self.stepperView.currentStep = 4
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
