//
//  ScheduleOptionsTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 02/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class ScheduleOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var mainHolderview: UIView!
    @IBOutlet weak var titleTextLable: UILabel!
    @IBOutlet weak var checkboxImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selectedView(_ isSelect : Bool)
    {
        if isSelect
        {
            checkboxImageview.backgroundColor = UIColor.appColor
            checkboxImageview.image = UIImage(named: "check")
            titleTextLable.textColor = UIColor(hexString: "444444")
        }
        else
        {
            checkboxImageview.backgroundColor = UIColor.clear
            checkboxImageview.image = UIImage(named: "")
            titleTextLable.textColor = UIColor(hexString: "A09F9F")
        }
    }
    
}
