//
//  UIVisualEffectView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 27.06.2023.
//

import UIKit

extension UIVisualEffectView {
    static func obtainBlur(style: UIBlurEffect.Style) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.masksToBounds = true
        return blurEffectView
    }
}
