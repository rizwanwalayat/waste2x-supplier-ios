//
//  SupplyingCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

class SupplyingCollectionViewCell: BaseCollectionViewCell {
    //MARK: - DATA
    struct CellData {
        var imageType: UIImage
        var labelTitle = String()
        
        
        
    }
    
    let FormData: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "Lump"), labelTitle: "Lump"),
        CellData(imageType: #imageLiteral(resourceName: "Loose"), labelTitle: "Loose"),
        CellData(imageType: #imageLiteral(resourceName: "Densified"), labelTitle: "Densified"),
        CellData(imageType: #imageLiteral(resourceName: "Baled"), labelTitle: "Baled"),
        CellData(imageType: #imageLiteral(resourceName: "Lump"), labelTitle: "Lump"),
        CellData(imageType: #imageLiteral(resourceName: "Loose"), labelTitle: "Loose"),
        CellData(imageType: #imageLiteral(resourceName: "Densified"), labelTitle: "Densified"),
        CellData(imageType: #imageLiteral(resourceName: "Baled"), labelTitle: "Baled")
    ]
//    let SupplyingType: [CellData] = [
//        CellData(imageType: #imageLiteral(resourceName: "Crop Icon"), labelTitle: "Crop Waste"),
//        CellData(imageType: #imageLiteral(resourceName: "bottle"), labelTitle: "Plastic Waste"),
//        CellData(imageType: #imageLiteral(resourceName: "food"), labelTitle: "Food Waste"),
//        CellData(imageType: #imageLiteral(resourceName: "Livestock Icon"), labelTitle: "LiveStock\nWaste"),
//        CellData(imageType: #imageLiteral(resourceName: "Cans"), labelTitle: "Inorganic\nWaste"),
//        CellData(imageType: #imageLiteral(resourceName: "Recycle Bin Icon"), labelTitle: "Other \nInorganic \nWaste"),
//        CellData(imageType: #imageLiteral(resourceName: "tire"), labelTitle: "Tire Waste")
//    ]
    
    let formLivestockData : [CellData] = [
        
        CellData(imageType: #imageLiteral(resourceName: "poultry"), labelTitle: "Poultry"),
        CellData(imageType: #imageLiteral(resourceName: "Hogs Icon"), labelTitle: "Hogs"),
        CellData(imageType: #imageLiteral(resourceName: "Cattle"), labelTitle: "Cattle")
    ]
    
    
    
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
