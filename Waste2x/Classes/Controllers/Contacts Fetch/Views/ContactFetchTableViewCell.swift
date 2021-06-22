//
//  ContactFetchTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 08/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class ContactFetchTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        
    }
}
