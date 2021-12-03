import UIKit

enum UIColorHex: String {
    case appColorCode = "#05413C"
    case controllerBgColor = "F4F7F4"
}

extension UIColor {
    static var appColor: UIColor {
        return UIColor(red: 5/255.0, green: 65/255.0, blue: 60/255.0, alpha: 1)
    }
    static var primary: UIColor {
        return UIColor(named: "primary") ?? UIColor(hexString: "007F97")
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
