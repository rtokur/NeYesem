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
    
    func sizeAndLineCount(using font: UIFont, maxWidth: CGFloat, padding: CGFloat = 0) -> (height: CGFloat, lineCount: Int) {
        
        let constraintSize = CGSize(width: maxWidth - padding, height: .greatestFiniteMagnitude)
        
        let boundingBox = (self as NSString).boundingRect(
            with: constraintSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        
        let lineHeight = font.lineHeight
        let lineCount = Int(ceil(boundingBox.height / lineHeight))
        
        return (height: ceil(boundingBox.height) + padding, lineCount: lineCount)
    }
}
