//
//  SupplyDetailTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

class SupplyDetailTableViewCell: UITableViewCell {

    
    //MARK: - DATA
    struct CellData {
        var imageType: UIImage
        var labelTitle = String()
        
        
        
    }
    
    let GradeData: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "A Icon"), labelTitle: "Grade A"),
        CellData(imageType: #imageLiteral(resourceName: "B Icon"), labelTitle: "Grade B"),
        CellData(imageType: #imageLiteral(resourceName: "C Icon"), labelTitle: "Grade C")
    ]
    let supplyType: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "Icon-2"), labelTitle: "HDPE 2"),
        CellData(imageType: #imageLiteral(resourceName: "Icon-1"), labelTitle: "LDPE 4"),
        CellData(imageType: #imageLiteral(resourceName: "Icon"), labelTitle: "PP 5"),
        CellData(imageType: #imageLiteral(resourceName: "PS6 Icon"), labelTitle: "PS 6")
    ]
    //MARK: - Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func selection(index:Int){
        
    }
    func configForType(_ title : String, _ imageStr : String){
        self.labelTitle.text = title
        
        if imageStr == ""
        {
            self.imgView.image = #imageLiteral(resourceName: "Icon")
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
    func configForGrade(_ title : String, imageStr : String){
        
        self.labelTitle.text = title
        
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
