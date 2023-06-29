//
//  WeatherIcon.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

struct WeatherIcon {
    
    var image: UIImage
    
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
    
    private init(_ image: UIImage) {
        self.image = image
    }
    
    static func obtainIcon(for weatherType: WeatherType, isDay: Bool) -> WeatherIcon {
        switch weatherType {
        case .clearSky:
            return isDay ? .sun : .moon
        case .partlyCloudy:
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
