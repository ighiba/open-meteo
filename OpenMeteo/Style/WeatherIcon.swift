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
    static let rainCloud = WeatherIcon(UIImage(named: "rain")!)
    
    static let fog = WeatherIcon(UIImage(named: "fog")!)

    static let snow = WeatherIcon(UIImage(named: "snow")!)
    
    static let thunderstorm = WeatherIcon(UIImage(named: "thunder")!)
    
    private init(_ image: UIImage) {
        self.image = image
    }
    
    static func obtainIcon(for weatherType: WeatherType, isDay: Bool) -> WeatherIcon {
        switch weatherType {
        case .clearSky:
            if isDay {
                return sun
            } else {
                return moon
            }
        case .cloudly:
            return cloud
        case .fog:
            return fog
        case .rain:
            return rainCloud
        case .snow:
            return snow
        case .thunderstorm:
            return thunderstorm
        }
    }
}
