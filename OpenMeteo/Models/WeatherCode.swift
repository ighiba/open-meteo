//
//  WeatherCode.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import Foundation

// Enum for WMO Weather interpretation codes
enum WeatherCode: Int16 {
    case clearSky = 0
    case mainlyClear = 1
    case partlyCloudy = 2
    case overcast = 3
    case fog = 45
    case depositingRimeFog = 48
    case drizzleLight = 51
    case drizzleModerate = 53
    case drizzleDense = 55
    case freezingDrizzleLight = 56
    case freezingDrizzleDense = 57
    case rainSlight = 61
    case rainModerate = 63
    case rainHeavy = 64
    case freezingRainLight = 66
    case freezingRainHeavy = 67
    case snowFallSlight = 71
    case snowFallModerate = 73
    case snowFallHeavy = 75
    case snowGrains = 77
    case rainShowersSlight = 80
    case rainShowersModerate = 81
    case rainShowersViolent = 82
    case snowShowersSlight = 85
    case snowShowersHeavy = 86
    case thunderstormSlightModerate = 95
    case thunderstormSlightHail = 96
    case thunderstormHeavyHail = 99

    var localizedDescription: String {
        return ""
    }
}

extension WeatherCode {
    func obtainWeatherType() -> WeatherType {
        switch self {
        case .clearSky,
             .mainlyClear,
             .partlyCloudy:
            return .clearSky
            
        case .overcast:
            return .cloudly
            
        case .fog,
             .depositingRimeFog:
            return .fog
            
        case .drizzleLight,
             .drizzleModerate,
             .drizzleDense,
             .freezingDrizzleLight,
             .freezingDrizzleDense,
             .rainSlight,
             .rainModerate,
             .rainHeavy,
             .freezingRainLight,
             .freezingRainHeavy,
             .rainShowersSlight,
             .rainShowersModerate,
             .rainShowersViolent:
            return .rain
            
        case .snowFallSlight,
             .snowFallModerate,
             .snowFallHeavy,
             .snowGrains,
             .snowShowersSlight,
             .snowShowersHeavy:
            return .snow
            
        case .thunderstormSlightModerate,
             .thunderstormSlightHail,
             .thunderstormHeavyHail:
            return .thunderstorm
            
        }
    }
}
