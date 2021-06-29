//
//  SupplyDetailTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 07/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit
import SDWebImage

class SupplyDetailTableViewCell: BaseTableViewCell {

    

    //MARK: - Outlets
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var tabaleViewIndex = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func selection(index:Int){
//                    if self.tabaleViewIndex == index {
//                        mainView.borderColor = UIColor(named: "themeColor")
//                        mainView.borderWidth = 2
//                    }
//                    else {
//                        mainView.borderColor = .clear
//                        mainView.borderWidth = 0
//                    }
    }
    func configForType(_ title : String, _ imageStr : String){
        self.labelTitle.text = title
        
        guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
        setImage(imageView: self.imgView, url: imageUrl)
        
    }
    func configForGrade(_ title : String, imageStr : String){
        
        self.labelTitle.text = title
        
        guard let imageUrl = URL(string: imageStr) else { print("URL not created for imagesURL String"); return }
        setImage(imageView: self.imgView, url: imageUrl)
    }
    
    
}
