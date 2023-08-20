//
//  UIVisualEffectView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 27.06.2023.
//

import UIKit

extension UIVisualEffectView {
    static func obtainBlur(style: UIBlurEffect.Style, withAlpha alpha: CGFloat = 1.0) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.masksToBounds = true
        blurEffectView.alpha = alpha
        return blurEffectView
    }
    
    func updateBlur(style: UIBlurEffect.Style, withAlpha newAlpha: CGFloat = 1.0) {
        let blurEffect = UIBlurEffect(style: style)
        effect = blurEffect
        layer.masksToBounds = true
        alpha = newAlpha
    }
}
