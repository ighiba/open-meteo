//
//  TemperaturePerception.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.02.2024.
//

import Foundation

enum TemperaturePerception {
    case noDifference
    case warmerBy(Float)
    case colderBy(Float)
    
    var localizedDescription: String {
        switch self {
        case .noDifference:
            return NSLocalizedString("No difference", comment: "")
        case .warmerBy(let difference):
            return String(format: NSLocalizedString("Warmer by %.0f°", comment: ""), difference)
        case .colderBy(let difference):
            return String(format: NSLocalizedString("Colder by %.0f°", comment: ""), difference)
        }
    }
    
    static func compareTemperatures(real realTemperature: Float, apparent apparentTemperature: Float) -> Self {
        let difference = realTemperature.rounded(.toNearestOrEven) - apparentTemperature.rounded(.toNearestOrEven)
        if difference == 0 {
            return .noDifference
        } else if difference < 0 {
            return .warmerBy(abs(difference))
        } else {
            return .colderBy(difference)
        }
    }
}
