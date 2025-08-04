//
//  String+Width.swift
//  YemekTarifleriApp
//
//  Created by Rumeysa Tokur on 4.08.2025.
//
import UIKit

extension String {
    func width(using font: UIFont, padding: CGFloat = 0) -> CGFloat {
        let size = (self as NSString).size(withAttributes: [.font: font])
        return size.width + padding
    }
}
