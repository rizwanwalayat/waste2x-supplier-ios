//
//  DetailTableViewCell.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 01/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class DetailTableViewCell: BaseTableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(data:NewsModel,index:Int){
        
        self.titleLabel.text = data.result[index].title
        self.dateLabel.text = self.dateCalculate(date: data.result[index].date_published)
        
        if let url = URL(string: data.result[index].picture) {
            
            self.setImage(imageView: self.imgView, url: url)
        }
        
        
        
    }
    
}
