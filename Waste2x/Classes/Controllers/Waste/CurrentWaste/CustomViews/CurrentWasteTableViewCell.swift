//
//  CurrentWasteTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class CurrentWasteTableViewCell: UITableViewCell {

    @IBOutlet weak var mainHolderView   : UIView!
    @IBOutlet weak var titleImageview   : UIImageView!
    @IBOutlet weak var siteTitleLabel   : UILabel!
    @IBOutlet weak var siteInfoLabel    : UILabel!
    @IBOutlet weak var wasteTitleLabel  : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainHolderView.dropShadow(color: UIColor(hexString: "969696", alpha: 1), opacity: 0.15, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
