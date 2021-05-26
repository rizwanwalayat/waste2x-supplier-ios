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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
