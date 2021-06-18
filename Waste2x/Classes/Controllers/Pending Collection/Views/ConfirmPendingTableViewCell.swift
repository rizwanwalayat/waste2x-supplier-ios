//
//  PendingTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import StepIndicator
class ConfirmPendingTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
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
        
        for dayLbl in daysLabel
        {
            dayLbl.sizeToFit()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func checkButtonAction(_ sender: Any) {
            
//        checkButton.isSelected = !checkButton.isSelected
        
    }
    
    
    //MARK: - Functions
    func confirmConfig(data:[PendingCollectionResultResponce],index:Int){
        let arrayCount = data[index].history.count
        
        self.farmLabel.text = data[index].farm
        if data[index].frequency == "" {
            self.scheduleLabel.text = data[index].schedule_type
        }
        
        else{
            self.scheduleLabel.text = data[index].schedule_type + " (\(data[index].frequency))"
            
        }
        self.dateLabel.text = data[index].scheduleDate
        
        //MARK: - Stepper
        

        for (indexNew, _) in data[index].history.enumerated() {
            
            if data[index].history[indexNew].status != "" && indexNew == 0 {
                
                self.activityDate1.text = data[index].history[indexNew].activityDate
                self.stepperView.currentStep = 0
            }
            
            else if data[index].history[1].status != "" && indexNew == 1 {
                self.activityDate2.text = data[index].history[indexNew].activityDate
                self.stepperView.currentStep = 1
            }
            else if data[index].history[2].status != "" && indexNew == 3 {
                self.activityDate3.text = data[index].history[indexNew].activityDate
                self.stepperView.currentStep = 2
            }
            else if data[index].history[3].status != "" && indexNew == 0 {
                self.activityDate4.text = data[index].history[indexNew].activityDate
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
