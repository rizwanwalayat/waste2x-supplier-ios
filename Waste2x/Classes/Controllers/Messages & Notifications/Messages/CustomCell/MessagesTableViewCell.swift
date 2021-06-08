//
//  MessagesTableViewCell.swift
//  Waste2x
//
//  Created by MAC on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mainHolderview : UIView!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
