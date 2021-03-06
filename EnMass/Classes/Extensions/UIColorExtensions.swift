import UIKit

enum UIColorHex: String {
    case appColorCode = "#004B44"
    case controllerBgColor = "F4F7F4"
}

extension UIColor {
    static var appColor: UIColor {
        return UIColor(red: 0/255.0, green: 75/255.0, blue: 68/255.0, alpha: 1)
    }
    static var primary: UIColor {
        return UIColor(named: "primary") ?? UIColor(hexString: "007F97")
    }
    static var secondary: UIColor {
        return UIColor(named: "secondary") ?? UIColor(hexString: "FBCE09")
    }
    static var highlight: UIColor {
        return UIColor(named: "highlight") ?? UIColor(hexString: "D9ECEF")
    }
    static var icons: UIColor {
        return UIColor(named: "icons") ?? UIColor(hexString: "91BE7F")
    }
    static var inactive: UIColor {
        return UIColor(named: "inactive") ?? UIColor(hexString: "B9B7C1")
    }
    static var tabText: UIColor {
        return UIColor(named: "tabText") ?? UIColor(hexString: "444444")
    }
    static var tabUnselected: UIColor {
        return UIColor(named: "tabUnselected") ?? UIColor(hexString: "EBEBEB")
    }
    static var lineColor: UIColor {
        return UIColor(named: "lineColor") ?? UIColor(hexString: "91BE7F")
    }
    static var successMessage: UIColor {
        return UIColor(named: "successMessage") ?? UIColor(hexString: "007F97")
    }
    static var successMessageTextIcon: UIColor {
        return UIColor(named: "successMessageTextIcon") ?? UIColor(hexString: "007F97")
    }
    static var failureMessageTextIcon: UIColor {
        return UIColor(named: "failureMessageTextIcon") ?? UIColor(hexString: "007F97")
    }
    static var failureMessage: UIColor {
        return UIColor(named: "failureMessage") ?? UIColor(hexString: "007F97")
    }
    static var badgeGreen: UIColor {
        return UIColor(named: "badgeGreen") ?? UIColor(hexString: "7D9D15")
    }
    static var badgeGreenBg: UIColor {
        return UIColor(named: "badgeGreenBg") ?? UIColor(hexString: "7D9D15", alpha: 0.15)
    }
    static var badgeYellow: UIColor {
        return UIColor(named: "badgeYellow") ?? UIColor(hexString: "F9C64A")
    }
    static var badgeYellowBg: UIColor {
        return UIColor(named: "badgeYellowBg") ?? UIColor(hexString: "FFD367", alpha: 0.15)
    }
    
    convenience init(hexString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
