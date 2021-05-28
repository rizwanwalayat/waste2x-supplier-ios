//
//  SideMenuItemsTableViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 25/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class SideMenuItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionView: UIView!
    
    
    //MARK: - Variables
    var img = [#imageLiteral(resourceName: "Payment Icons"),#imageLiteral(resourceName: "Calendar")]
    var text = ["Payments","Schedule Pickup"]
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(index:Int) {
        self.imgView.image = img[index]
        self.nameLabel.text = text[index]
    }
    
}
