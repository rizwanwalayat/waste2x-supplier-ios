//
//  SupplierTableViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

var globalObjectSupplier : SupplierTableViewCell?
class SupplierTableViewCell: BaseTableViewCell {

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
    func config(_ imageStr : String){
        
        guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
        setImage(imageView: self.imgView, url: imageUrl)
    }
    
    func pendingCOllectionConfig(){
        self.imgView.image = UIImage(named: "pending")
        self.imgHeight.constant = self.frame.height * 0.5//100
        self.imgEqualizerConstraint.constant = 0
        self.titleLabel.text = "Pending \nCollection"
        self.descriptionLabel.text = "You have pickup schdule\n time to be confirmed."
    }
    
}
