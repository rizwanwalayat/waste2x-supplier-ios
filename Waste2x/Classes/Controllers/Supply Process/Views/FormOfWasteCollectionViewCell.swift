//
//  FormOfWasteCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class FormOfWasteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    //MARK: - DATA
    struct CellData {
        var imageType: UIImage
        var labelTitle = String()
        
        
        
    }
    
    let tableViewData: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "tire"), labelTitle: "Tire"),
        CellData(imageType: #imageLiteral(resourceName: "poultry"), labelTitle: "Cattle"),
        CellData(imageType: #imageLiteral(resourceName: "food"), labelTitle: "Food")
    ]
    
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
