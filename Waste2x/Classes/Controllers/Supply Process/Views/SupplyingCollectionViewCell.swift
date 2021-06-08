//
//  SupplyingCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class SupplyingCollectionViewCell: UICollectionViewCell {
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
    let SupplyingType: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "Crop Icon"), labelTitle: "Crop Waste"),
        CellData(imageType: #imageLiteral(resourceName: "bottle"), labelTitle: "Plastic Waste"),
        CellData(imageType: #imageLiteral(resourceName: "food"), labelTitle: "Food Waste"),
        CellData(imageType: #imageLiteral(resourceName: "Livestock Icon"), labelTitle: "LiveStock\nWaste"),
        CellData(imageType: #imageLiteral(resourceName: "Cans"), labelTitle: "Inorganic\nWaste"),
        CellData(imageType: #imageLiteral(resourceName: "Recycle Bin Icon"), labelTitle: "Other \nInorganic \nWaste"),
        CellData(imageType: #imageLiteral(resourceName: "tire"), labelTitle: "Tire Waste")
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
    func configForSupplying(index:Int){
        self.imgView.image = SupplyingType[index].imageType
        self.titleLabel.text = SupplyingType[index].labelTitle
    }
    func configForForm(index:Int){
        self.imgView.image = FormData[index].imageType
        self.titleLabel.text = FormData[index].labelTitle
    }
    

}
