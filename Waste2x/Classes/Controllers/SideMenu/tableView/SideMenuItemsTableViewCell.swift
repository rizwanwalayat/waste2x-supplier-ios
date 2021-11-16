//
//  SideMenuItemsTableViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 25/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class SideMenuItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(item :SideMenuItems) {
        
        self.imgView.image = item.selectedImage
        self.nameLabel.text = item.rawValue
    }
    
}
