//
//  UIColor.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 28.07.2025.
//

import UIKit

extension UIColor {
    static var primaryColor: UIColor {
        return UIColor(named: "CustomPrimaryColor")!
    }
    
    static var secondaryColor: UIColor {
        return UIColor(named: "CustomSecondaryColor")!
    }
    
    static var textColor800: UIColor {
        return UIColor(named: "Text800")!
    }
    
    static var textColor300: UIColor {
        return UIColor(named: "Text300")!
    }
    
    static var D8DADC: UIColor {
        return UIColor(named: "D8DADC")!
    }
    
    static var textColor400: UIColor {
        return UIColor(named: "Text400")!
    }
    
    static var textColor500: UIColor {
        return UIColor(named: "Text500")!
    }
    
    static var textColor900: UIColor {
        return UIColor(named: "Text900")!
    }
    
    static var Color10: UIColor {
        return UIColor(named: "Color10")!
    }
    
    static var Primary950: UIColor {
        return UIColor(named: "Primary950")!
    }
    
    static var Text950: UIColor {
        return UIColor(named: "Text950")!
    }
    
    static var Text50: UIColor {
        return UIColor(named: "Text50")!
    }
    
    static var Color03: UIColor {
        return UIColor(named: "Color03")!
    }
    
    static var Color999999: UIColor {
        return UIColor(named: "999999")!
    }
    
    static var Text200: UIColor {
        return UIColor(named: "Text200")!
    }
    
    static var Primary800: UIColor {
        return UIColor(named: "Primary800")!
    }
    
    static var Primary900: UIColor {
        return UIColor(named: "Primary900")!
    }
    
    static var Secondary800: UIColor {
        return UIColor(named: "Secondary800")!
    }
    
    static var Secondary100: UIColor {
        return UIColor(named: "Secondary100")!
    }
    
    static var Text100: UIColor {
        return UIColor(named: "Text100")!
    }
    
    static var Text600: UIColor {
        return UIColor(named: "Text600")!
    }
    
    static var Color226A0D: UIColor {
        return UIColor(named: "226A0D")!
    }
    
    static var Color4B24CB: UIColor {
        return UIColor(named: "4B24CB")!
    }
    
    static var ColorCB2488: UIColor {
        return UIColor(named: "CB2488")!
    }
    
    static var Color97CE4E: UIColor {
        return UIColor(named: "97CE4E")!
    }
    
    static var Color53D5D7: UIColor {
        return UIColor(named: "53D5D7")!
    }
    
    static var ColorA81FE3: UIColor {
        return UIColor(named: "A81FE3")!
    }
    
    static var ColorD92427: UIColor {
        return UIColor(named: "D92427")!
    }
    
    convenience init?(hex: String) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        guard hexFormatted.count == 6,
              let rgbValue = UInt64(hexFormatted, radix: 16) else { return nil }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1.0
        )
    }
}

