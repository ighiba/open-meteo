//
//  UILabel+NSShadow.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit

extension UILabel {
    func setAttributedTextWithShadow(_ text: String, alpha: CGFloat = 0.2) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(alpha)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = self.textAlignment
            
        let attributedString = NSAttributedString(string: text,
                                               attributes: [
                                                    .font: font ?? UIFont.systemFont(ofSize: 18),
                                                    .foregroundColor: textColor ?? .black,
                                                    .shadow: shadow,
                                                    .paragraphStyle: paragraphStyle
                                               ])
        
        attributedText = attributedString
        sizeToFit()
    }
    
    func attributedStringSetMultilineText() {
        guard let attrText = attributedText else { return }
        let attributedString = NSMutableAttributedString(attributedString: attrText)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: range)
        
        numberOfLines = 0

        attributedText = attributedString
        sizeToFit()
    }
}
