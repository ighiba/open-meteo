//
//  WeatherColorSet+SkyType.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import Foundation

extension WeatherColorSet {
    static func obtainColorSet(fromSkyType skyType: SkyType) -> WeatherColorSet {
        switch skyType {
        case .day:     return .clearSky
        case .night:   return .midnightSky
        case .sunrise: return .sunriseSky
        case .sunset:  return .sunsetSky
        case .cloudy:  return .clodySky
        case .rain:    return .rainSky
        }
    }
}
