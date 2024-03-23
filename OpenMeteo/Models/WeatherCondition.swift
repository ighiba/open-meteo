//
//  WeatherCondition.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 22.03.2024.
//

import Foundation

extension Weather {
    enum Condition {
        case clearSky
        case partiallyCloudy
        case overcast
        case fog
        case drizzle
        case rain
        case rainHeavy
        case hail
        case snow
        case thunderstorm
    }
}

extension Weather.Code {
    func obtainWeatherCondition() -> Weather.Condition {
        switch self {
        case .clearSky,
             .mainlyClear:
            return .clearSky
            
        case .partlyCloudy:
            return .partiallyCloudy
            
        case .overcast:
            return .overcast
            
        case .fog,
             .depositingRimeFog:
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
