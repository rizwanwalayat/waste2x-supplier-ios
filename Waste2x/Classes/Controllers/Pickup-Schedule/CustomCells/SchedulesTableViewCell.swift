//
//  SchedulesTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

enum ScheduleType {
    case onePickup
    case regularSchedule
    case site
    case location
    case dateAndTime
    case FrequencyAndPeriodic
}
class SchedulesTableViewCell: UITableViewCell {


    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var titleLableHolderview: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyHolderview: UIView!
    @IBOutlet weak var checkboxImageView: UIImageView!
    @IBOutlet weak var bodyTitleLabel: UILabel!
    @IBOutlet weak var bodyRightImageview: UIImageView!
    @IBOutlet weak var sepratorview: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func UIAdjustment(cellType : ScheduleType, _ isSelected: Bool, bodyLabelText : String?)
    {
        switch cellType {
        case .onePickup:
            
            self.titleLableHolderview.isHidden = true
            self.bodyRightImageview.isHidden = true
            self.checkboxImageView.isHidden = false
            self.bodyTitleLabel.text = "Only one pick-up"
            bodyHolderview.backgroundColor = UIColor(hexString: "FFFFFF")
            self.sepratorview.isHidden = true
            setHighlightedView(isSelected)
            
        case .regularSchedule:
            
            self.titleLableHolderview.isHidden = true
            self.bodyRightImageview.isHidden = true
            self.checkboxImageView.isHidden = false
            self.bodyTitleLabel.text = "Regular schedule"
            bodyHolderview.backgroundColor = UIColor(hexString: "FFFFFF")
            self.sepratorview.isHidden = false
            setHighlightedView(isSelected)
            
        case .site:
            
            self.titleLableHolderview.isHidden = false
            self.bodyRightImageview.isHidden = false
            self.checkboxImageView.isHidden = true
            self.bodyTitleLabel.text = (bodyLabelText != nil) ? bodyLabelText :"Select Site"
            self.titleLabel.text = "Site"
            self.bodyRightImageview.image = UIImage(named: "down Arrow gray")
            self.sepratorview.isHidden = true
            setHighlightedView(isSelected)
            
        case .dateAndTime:
            
            self.titleLableHolderview.isHidden = false
            self.bodyRightImageview.isHidden = false
            self.checkboxImageView.isHidden = true
            self.bodyTitleLabel.text = (bodyLabelText != nil) ? bodyLabelText :"Select Date and Time"
            self.titleLabel.text = "Date & Time"
            self.bodyRightImageview.image = UIImage(named: "calendar-dates-gray")
            self.sepratorview.isHidden = true
            setHighlightedView(isSelected)
            
        case .location:
            
            self.titleLableHolderview.isHidden = false
            self.bodyRightImageview.isHidden = false
            self.checkboxImageView.isHidden = true
            self.bodyTitleLabel.text = (bodyLabelText != nil) ? bodyLabelText :"Select Location"
            self.titleLabel.text = "Location"
            self.bodyRightImageview.image = UIImage(named: "location-pin")
            self.sepratorview.isHidden = true
            setHighlightedView(isSelected)
        
        case .FrequencyAndPeriodic:
            
            self.titleLableHolderview.isHidden = false
            self.bodyRightImageview.isHidden = false
            self.checkboxImageView.isHidden = true
            self.bodyTitleLabel.text = "Select Frequency / Periodic"
            self.titleLabel.text = (bodyLabelText != nil) ? bodyLabelText :"Frequency / Periodic"
            self.bodyRightImageview.image = UIImage(named: "down Arrow gray")
            self.sepratorview.isHidden = true
            setHighlightedView(isSelected)
        }
    }
    
    func setHighlightedView(_ isTrue : Bool)
    {
        if isTrue
        {
            bodyHolderview.borderWidth = 1
            bodyHolderview.animateBorderColor(toColor: UIColor.appColor, duration: 0.3)//borderColor = UIColor.appColor
            checkboxImageView.backgroundColor = UIColor.appColor
            checkboxImageView.image = UIImage(named: "check")
        }
        else
        {
            bodyHolderview.borderWidth = 0
            bodyHolderview.animateBorderColor(toColor: UIColor.clear, duration: 0.3) //borderColor = UIColor.clear
            checkboxImageView.backgroundColor = UIColor.clear
            checkboxImageView.image = UIImage(named: "")
        }
    }
}
