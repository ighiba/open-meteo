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
        switch self {
        case .clearSky:
            return NSLocalizedString("Clear sky", comment: "")
        case .mainlyClear:
            return NSLocalizedString("Mainly clear", comment: "")
        case .partlyCloudy:
            return NSLocalizedString("Partly cloudy", comment: "")
        case .overcast:
            return NSLocalizedString("Overcast", comment: "")
        case .fog:
            return NSLocalizedString("Fog", comment: "")
        case .depositingRimeFog:
            return NSLocalizedString("Depositing rime fog", comment: "")
        case .drizzleLight:
            return NSLocalizedString("Light drizzle", comment: "")
        case .drizzleModerate:
            return NSLocalizedString("Moderate drizzle", comment: "")
        case .drizzleDense:
            return NSLocalizedString("Dense drizzle", comment: "")
        case .freezingDrizzleLight:
            return NSLocalizedString("Light freezing drizzle", comment: "")
        case .freezingDrizzleDense:
            return NSLocalizedString("Dense freezing drizzle", comment: "")
        case .rainSlight:
            return NSLocalizedString("Slight rain", comment: "")
        case .rainModerate:
            return NSLocalizedString("Moderate rain", comment: "")
        case .rainHeavy:
            return NSLocalizedString("Heavy rain", comment: "")
        case .freezingRainLight:
            return NSLocalizedString("Light freezing rain", comment: "")
        case .freezingRainHeavy:
            return NSLocalizedString("Heavy freezing rain", comment: "")
        case .snowFallSlight:
            return NSLocalizedString("Slight snow fall", comment: "")
        case .snowFallModerate:
            return NSLocalizedString("Moderate snow fall", comment: "")
        case .snowFallHeavy:
            return NSLocalizedString("Heavy snow fall", comment: "")
        case .snowGrains:
            return NSLocalizedString("Snow grains", comment: "")
        case .rainShowersSlight:
            return NSLocalizedString("Slight rain showers", comment: "")
        case .rainShowersModerate:
            return NSLocalizedString("Moderate rain showers", comment: "")
        case .rainShowersViolent:
            return NSLocalizedString("Violent rain showers", comment: "")
        case .snowShowersSlight:
            return NSLocalizedString("Slight snow showers", comment: "")
        case .snowShowersHeavy:
            return NSLocalizedString("Hevy snow showers", comment: "")
        case .thunderstormSlightModerate:
            return NSLocalizedString("Moderate thunderstorm", comment: "")
        case .thunderstormSlightHail:
            return NSLocalizedString("Slight hail thunderstorm", comment: "")
        case .thunderstormHeavyHail:
            return NSLocalizedString("Heavy hail thunderstorm", comment: "")
        }
    }
}

extension WeatherCode {
    func obtainWeatherType() -> WeatherType {
        switch self {
        case .clearSky, .mainlyClear:
            return .clearSky
            
        case .partlyCloudy:
            return .partlyCloudy
            
        case .overcast:
            return .overcast
            
        case .fog, .depositingRimeFog:
            return .fog
            
        case .drizzleLight,
             .drizzleModerate,
             .drizzleDense,
             .freezingDrizzleLight,
             .freezingDrizzleDense:
            return .drizzle
            
        case .rainSlight,
             .rainModerate,
             .freezingRainLight,
             .rainShowersSlight:
            return .rain
            
        case .rainHeavy,
             .freezingRainHeavy,
             .rainShowersModerate,
             .rainShowersViolent:
            return .rainHeavy
            
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
