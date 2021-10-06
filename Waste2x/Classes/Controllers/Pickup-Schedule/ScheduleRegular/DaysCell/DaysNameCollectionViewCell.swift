//
//  DaysNameCollectionViewCell.swift
//  Waste2x
//
//  Created by MAC on 06/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class DaysNameCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var mainHolderView: UIView!
    @IBOutlet weak var daysValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func selectedItems()
    {
        mainHolderView.backgroundColor = UIColor.appColor
        daysValueLabel.textColor = .white
    }
    
    func unSelectedItems()
    {
        mainHolderView.backgroundColor = .white
        daysValueLabel.textColor = UIColor(hexString: "2A2A2A")
    }
    
    
}
