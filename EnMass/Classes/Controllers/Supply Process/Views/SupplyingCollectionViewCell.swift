//
//  SupplyingCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import UIKit
import SDWebImage

class SupplyingCollectionViewCell: BaseCollectionViewCell {
    //MARK: - IBOutlets

    
    @IBOutlet weak var mainViewSelection: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func selection(index:Int){
        
    }
    func configForSupplying(_ title : String, _ imageStr : String)
    {
        self.titleLabel.text = title
        
        guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
        setImage(imageView: self.imgView, url: imageUrl)
    }
    
    func configForForm(_ title :String, _ imageStr : String){
        
        self.titleLabel.text = title
        
        guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
        setImage(imageView: self.imgView, url: imageUrl)
    }
    

}
