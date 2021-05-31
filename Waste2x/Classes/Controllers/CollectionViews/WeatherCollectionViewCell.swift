//
//  WeatherCollectionViewCell.swift
//  Waste2x
//
//  Created by HaiD3R AwaN on 26/05/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cloudImgView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func config()
    {
//        self.mainView.backgroundColor = .none
    }

}
