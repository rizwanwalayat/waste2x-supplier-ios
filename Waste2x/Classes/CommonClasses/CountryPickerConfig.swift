//
//  CountryPickerConfig.swift
//  Waste2x
//
//  Created by MAC on 02/09/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import UIKit
import Columbus

struct CountryPickerConfig: Configurable {

    var displayState = CountryPickerViewController.DisplayState.countryCodeSelection
    /// In this example this has to be a computed property so the font object
    /// is calculated later on demand. Since this object is created right at app
    /// start something related to dynamic type seems not to be ready yet.
    var textAttributes: [NSAttributedString.Key: Any] {
        [
            .foregroundColor: UIColor.black,
            .font: UIFont.preferredFont(forTextStyle: .body)
        ]
    }
    var textFieldBackgroundColor: UIColor = UIColor(hexString: "E5E5E5")
    var backgroundColor: UIColor = .white
    var selectionColor: UIColor = .appColor
    var controlColor: UIColor = .black
    var lineColor: UIColor = .darkGray
    var lineWidth: CGFloat = 1.0 / UIScreen.main.scale
    var rasterSize: CGFloat = 10.0
    var separatorInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0, left: rasterSize * 4.7, bottom: 0, right: rasterSize * 2.5)
    }
    let searchBarAttributedPlaceholder: NSAttributedString = {
        NSAttributedString(string: "Search",
                           attributes: [
                            .foregroundColor: UIColor.lightGray,
                            .font: UIFont.preferredFont(forTextStyle: .body)])
    }()
}
