//
//  WeatherIcon.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

struct WeatherIcon {
    
    static let sun = WeatherIcon(UIImage(named: "sun")!)
    static let moon = WeatherIcon(UIImage(named: "moon")!)

    static let cloud = WeatherIcon(UIImage(named: "cloud")!)
    static let cloudSun = WeatherIcon(UIImage(named: "cloud.sun")!)
    static let cloudMoon = WeatherIcon(UIImage(named: "cloud.moon")!)
    
    static let rain = WeatherIcon(UIImage(named: "rain")!)
    static let rainDrizzle = WeatherIcon(UIImage(named: "rain.drizzle")!)
    static let rainHeavy = WeatherIcon(UIImage(named: "rain.heavy")!)
    
    static let hail = WeatherIcon(UIImage(named: "rain.hail")!)
    
    static let fog = WeatherIcon(UIImage(named: "fog")!)

    static let snow = WeatherIcon(UIImage(named: "snow")!)
    
    static let thunderstorm = WeatherIcon(UIImage(named: "thunder")!)
    
    var image: UIImage
    
    private init(_ image: UIImage) {
        self.image = image
    }
    
    static func obtainIcon(for weatherCondition: Weather.Condition, isDay: Bool) -> WeatherIcon {
        switch weatherCondition {
        case .clearSky:
            return isDay ? .sun : .moon
        case .partiallyCloudy:
            return isDay ? .cloudSun : .cloudMoon
        case .overcast:
            return cloud
        case .fog:
            return fog
        case .drizzle:
            return .rainDrizzle
        case .rain:
            return .rain
        case .rainHeavy:
            return .rainHeavy
        case .hail:
            return .hail
        case .snow:
            return .snow
        case .thunderstorm:
            return .thunderstorm
        }
    }
}
