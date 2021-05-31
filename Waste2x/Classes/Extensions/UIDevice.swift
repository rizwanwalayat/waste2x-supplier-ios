//
//  UIDevice.swift
//  Audtix
//
//  Created by Muhammad Shahrukh on 15/11/2019.
//  Copyright © 2019 Bilal Saeed. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}
extension UIDevice {

    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: Int {
        case iPhones_4_4S = 4
        case iPhones_5_5s_5c_SE = 5
        case iPhones_6_6s_7_8 = 6
        case iPhones_6Plus_6sPlus_7Plus_8Plus = 8
        case iPhones_X_XS = 10
        case iPhone_XR = 11
        case iPhone_XSMax = 12
        case unknown = 0
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhones_4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax
        default:
            return .unknown
        }
    }
}
