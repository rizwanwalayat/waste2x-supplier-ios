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
    
    let tableViewData: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "tire"), labelTitle: "Tire Waste"),
        CellData(imageType: #imageLiteral(resourceName: "bottle"), labelTitle: "Factory"),
        CellData(imageType: #imageLiteral(resourceName: "food"), labelTitle: "Food Waste"),
        CellData(imageType: #imageLiteral(resourceName: "poultry"), labelTitle: "Cattle Waste"),
        CellData(imageType: #imageLiteral(resourceName: "bottle"), labelTitle: "Hello"),
        CellData(imageType: #imageLiteral(resourceName: "food"), labelTitle: "Food Waste"),
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
    func config(index:Int){
        self.imgView.image = tableViewData[index].imageType
        self.titleLabel.text = tableViewData[index].labelTitle
    }

}
