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
        let style = NSMutableParagraphStyle()
        style.alignment = self.textAlignment
            
        let attributedText = NSAttributedString(string: text,
                                               attributes: [
                                                    .font: self.font ?? UIFont.systemFont(ofSize: 18),
                                                    .foregroundColor: self.textColor ?? .black,
                                                    .shadow: shadow,
                                                    .paragraphStyle: style
                                               ])
        
        self.attributedText = attributedText
        
        self.sizeToFit()
    }
}
