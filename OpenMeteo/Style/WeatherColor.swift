//
//  WeatherColor.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

struct WeatherColor {
    
    let uiColor: UIColor
    
    private init(_ color: UIColor) {
        self.uiColor = color
    }
    
    static let clearSkyTop               = WeatherColor(UIColor(named: "ClearSky-top")!)
    static let clearSkyBottom            = WeatherColor(UIColor(named: "ClearSky-bottom")!)
    
    static let sunriseTop                = WeatherColor(UIColor(named: "Sunrise-top")!)
    static let sunriseBottom             = WeatherColor(UIColor(named: "Sunrise-bottom")!)
    
    static let sunsetTop                 = WeatherColor(UIColor(named: "Sunset-top")!)
    static let sunsetBottom              = WeatherColor(UIColor(named: "Sunset-bottom")!)
    
    static let rainTop                   = WeatherColor(UIColor(named: "Rain-top")!)
    static let rainBottom                = WeatherColor(UIColor(named: "Rain-bottom")!)
    
    static let cloudyTop                 = WeatherColor(UIColor(named: "Cloudy-top")!)
    static let cloudyBottom              = WeatherColor(UIColor(named: "Cloudy-bottom")!)

    static let partiallyCloudyDayTop      = WeatherColor(UIColor(named: "PartiallyCloudyDay-top")!)
    static let partiallyCloudyDayBottom   = WeatherColor(UIColor(named: "PartiallyCloudyDay-bottom")!)
    
    static let partiallyCloudyNightTop    = WeatherColor(UIColor(named: "PartiallyCloudyNight-top")!)
    static let partiallyCloudyNightBottom = WeatherColor(UIColor(named: "PartiallyCloudyNight-bottom")!)
    
    static let midnightTop               = WeatherColor(UIColor(named: "Midnight-top")!)
    static let midnightBottom            = WeatherColor(UIColor(named: "Midnight-bottom")!)
}
