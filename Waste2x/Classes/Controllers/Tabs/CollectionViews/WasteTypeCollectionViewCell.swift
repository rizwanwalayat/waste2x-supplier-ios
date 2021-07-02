//
//  WasteTypeCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import SDWebImage

class WasteTypeCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func config(_ title : String, _ detail : String, _ imageStr : String)
    {
        self.titleLabel.text = title
        self.descriptionLabel.text = detail
        
        guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
        setImage(imageView: self.imgView, url: imageUrl)
    }

}
