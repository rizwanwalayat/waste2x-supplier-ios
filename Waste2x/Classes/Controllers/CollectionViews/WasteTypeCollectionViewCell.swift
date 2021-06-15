//
//  WasteTypeCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

class WasteTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var title = ["site 1","site 2","site 3","site 4"]
    var descrip = ["Cattle","Factory","Tire Dealer","Restaurent"]
    var images = [#imageLiteral(resourceName: "poultry"),#imageLiteral(resourceName: "bottle"),#imageLiteral(resourceName: "tire"),#imageLiteral(resourceName: "food")]
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func config(_ title : String, _ detail : String, _ imageStr : String)
    {
        self.titleLabel.text = title
        self.descriptionLabel.text = detail
        
        if imageStr == ""
        {
            self.imgView.image = nil
        }
        else
        {
            
            if let image = SDImageCache.shared.imageFromCache(forKey: imageStr )
            {
                
                self.imgView.image = image
            }
            else
            {
                guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
                
                self.imgView.sd_setImage(with: imageUrl, placeholderImage: nil,options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
                    
                    if image != nil
                    {
                        SDImageCache.shared.store(image, forKey: (imageStr), completion: nil)
                        self.imgView.image = image
                    }
                })
            }
        }
    }

}
