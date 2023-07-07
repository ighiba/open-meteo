//
//  UINavigationBarAppearance.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 07.07.2023.
//

import UIKit

extension UINavigationBarAppearance {
    class func configureDefaultBackgroundAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
    
    class func configureTransparentBackgroundAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        return appearance
    }
}
