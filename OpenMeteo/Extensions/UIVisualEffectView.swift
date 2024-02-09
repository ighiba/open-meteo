//
//  UIVisualEffectView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 27.06.2023.
//

import UIKit

extension UIVisualEffectView {
    static func configureBlur(style: UIBlurEffect.Style, withAlpha alpha: CGFloat = 1.0) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.layer.masksToBounds = true
        blurEffectView.alpha = alpha
        
        return blurEffectView
    }
    
    func updateBlur(style: UIBlurEffect.Style, withAlpha newAlpha: CGFloat) {
        updateBlur(style: style)
        alpha = newAlpha
    }
    
    func updateBlur(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        effect = blurEffect
        layer.masksToBounds = true
    }
}
