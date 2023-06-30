//
//  StyledContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit

protocol StyledContainer {
    func updateContainerStyle(with style: ContainerStyle)
}

enum ContainerStyle {
    case light
    case dark
    
    var alpha: CGFloat {
        switch self {
        case .light:
            return 0.15
        case .dark:
            return 0.2
        }
    }
    
    var blurStyle: UIBlurEffect.Style {
        switch self {
        case .light:
            return .systemThinMaterialLight
        case .dark:
            return .systemChromeMaterialDark
        }
    }
}

extension ContainerStyle {
    static func obtainContainerStyle(for skyType: SkyType) -> ContainerStyle {
        switch skyType {
        case .day, .sunrise, .sunset, .cloudy, .rain, .partiallyCloudyDay:
            return .dark
        case .night, .partiallyCloudyNight:
            return .light
        }
    }
}
