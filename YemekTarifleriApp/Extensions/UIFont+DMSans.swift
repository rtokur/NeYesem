//
//  UIFont+DMSans.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 27.07.2025.
//

import UIKit

extension UIFont {
    static func dmSansRegular(_ size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont(name: "DMSans-Regular", size: size)!
    }

    static func dmSansSemiBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-SemiBold", size: size)!
    }
    
    static func dmSansBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "DMSans-Bold", size: size)!
    }
}
