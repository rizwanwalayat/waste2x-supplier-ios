//
//  SupplierTableViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
var globalObjectSupplier : SupplierTableViewCell?
class SupplierTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var imgEqualizerConstraint: NSLayoutConstraint!
    var images = [#imageLiteral(resourceName: "Garbage Man Illustration"),#imageLiteral(resourceName: "factory Worker"),#imageLiteral(resourceName: "Farmer"),#imageLiteral(resourceName: "foodfix")]
    var pendingCollectionCheck = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(index:Int){
            self.imgView.image = images[index]
    }
    func pendingCOllectionConfig(){
        self.imgView.image = UIImage(named: "pending")
        self.imgHeight.constant = 100
        self.imgEqualizerConstraint.constant = 0
        self.titleLabel.text = "Pending \nCollection"
        self.descriptionLabel.text = "You have pickup schdule\n time to be confirmed."
    }
    
}
