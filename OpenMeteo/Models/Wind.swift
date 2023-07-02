//
//  Wind.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import Foundation

struct Wind {
    var speed: Float
    var direction: Int16
}

enum WindDirection {
    case north
    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest
    
    var localizedDescriptionShort: String {
        switch self {
        case .north:
            return NSLocalizedString("N", comment: "")
        case .northEast:
            return NSLocalizedString("NE", comment: "")
        case .east:
            return NSLocalizedString("E", comment: "")
        case .southEast:
            return NSLocalizedString("SE", comment: "")
        case .south:
            return NSLocalizedString("S", comment: "")
        case .southWest:
            return NSLocalizedString("SW", comment: "")
        case .west:
            return NSLocalizedString("W", comment: "")
        case .northWest:
            return NSLocalizedString("NW", comment: "")
        }
    }

    static func obtain(by windDirection: Int16) -> WindDirection? {
        switch windDirection {
        case 360, 0...45:
            return .north
        case 46...90:
            return .northEast
        case 91...135:
            return .east
        case 135...180:
            return .southEast
        case 181...225:
            return .south
        case 226...270:
            return .southWest
        case 271...315:
            return .west
        case 316...360:
            return .northWest
        default:
            return nil
        }
    }
}
