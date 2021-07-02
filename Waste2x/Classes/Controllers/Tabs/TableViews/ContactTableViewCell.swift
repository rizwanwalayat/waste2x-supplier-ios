//
//  ContactTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 27/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var text = ["Message Us","Call Us"]
    var img = [#imageLiteral(resourceName: "Message-1"),#imageLiteral(resourceName: "Call Icon")]
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func nextActionButton(_ sender: Any) {
        
    }
    func config(index: Int){
        self.imgView.image = img[index]
        self.titleLabel.text = text[index]
    }
    
    
}
