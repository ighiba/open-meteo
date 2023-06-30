//
//  WeatherColorSet.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

struct WeatherColorSet {
    
    var topColor: UIColor
    var bottomColor: UIColor
    
    private init(top topColor: WeatherColor, bottom bottomColor: WeatherColor) {
        self.topColor = topColor.uiColor
        self.bottomColor = bottomColor.uiColor
    }
    
    static let clearSky = WeatherColorSet(top: .clearSkyTop, bottom: .clearSkyBottom)
    static let sunriseSky = WeatherColorSet(top: .sunriseTop, bottom: .sunriseBottom)
    static let sunsetSky = WeatherColorSet(top: .sunsetTop, bottom: .sunsetBottom)
    static let rainSky = WeatherColorSet(top: .rainTop, bottom: .rainBottom)
    static let clodySky = WeatherColorSet(top: .cloudyTop, bottom: .cloudyBottom)
    static let partiallyCloudyDaySky = WeatherColorSet(top: .partiallyCloudyDayTop, bottom: .partiallyCloudyDayBottom)
    static let partiallyCloudyNightSky = WeatherColorSet(top: .partiallyCloudyNightTop, bottom: .partiallyCloudyNightBottom)
    static let midnightSky = WeatherColorSet(top: .midnightTop, bottom: .midnightBottom)
}
