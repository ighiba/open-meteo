//
//  UILabel+NSShadow.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit

extension UILabel {
    func setAttributedTextWithShadow(_ text: String) {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black.withAlphaComponent(0.2)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 4

        let attributedText = NSAttributedString(string: text,
                                               attributes: [
                                                    .font: self.font ?? UIFont.systemFont(ofSize: 18),
                                                    .foregroundColor: self.textColor ?? .black,
                                                    .shadow: shadow
                                                 ])
        
        self.attributedText = attributedText
        
        self.sizeToFit()
    }
}
