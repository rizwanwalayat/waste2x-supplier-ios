//
//  GoogleLocationAutoCompleteTableViewCell.swift
//  CleaningPal
//
//  Created by Bilal Saeed on 5/5/20.
//  Copyright © 2020 Neighbiz Pty.Ltd. All rights reserved.
//

import UIKit
import GooglePlaces


class GoogleLocationAutoCompleteTableViewCell: UITableViewCell {

    
    //MARK: - Outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationDetailLabel: UILabel!
    
    
    
    //MARK: - UIView Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: - Public Methods
    func configure(data: GMSAutocompletePrediction) {
        self.locationLabel.attributedText = data.attributedPrimaryText
        self.locationDetailLabel.attributedText = data.attributedSecondaryText
    }
}
