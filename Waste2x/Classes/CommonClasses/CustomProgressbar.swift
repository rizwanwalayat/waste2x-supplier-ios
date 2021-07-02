//
//  CustomProgressbar.swift
//  Waste2x
//
//  Created by MAC on 01/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import UIKit

class CustomProgressView: UIProgressView {

    var height:CGFloat = 1.0
    // Do not change this default value,
    // this will create a bug where your progressview wont work for the first x amount of pixel.
    // x being the value you put here.

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let size:CGSize = CGSize.init(width: self.frame.size.width, height: height)

        return size
    }

}
