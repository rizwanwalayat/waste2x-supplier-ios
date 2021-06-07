//
//  SupplyDetailTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class SupplyDetailTableViewCell: UITableViewCell {

    
    //MARK: - DATA
    struct CellData {
        var imageType: UIImage
        var labelTitle = String()
        
        
        
    }
    
    let tableViewData: [CellData] = [
        CellData(imageType: #imageLiteral(resourceName: "tire"), labelTitle: "HDPI 1"),
        CellData(imageType: #imageLiteral(resourceName: "bottle"), labelTitle: "LDPI 4"),
        CellData(imageType: #imageLiteral(resourceName: "food"), labelTitle: "PP 5"),
        CellData(imageType: #imageLiteral(resourceName: "poultry"), labelTitle: "PS 6"),
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
    func config(index:Int){
        self.imgView.image = tableViewData[index].imageType
        self.labelTitle.text = tableViewData[index].labelTitle
    }
    
}
