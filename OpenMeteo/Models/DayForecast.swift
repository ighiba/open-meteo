//
//  DayForecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import Foundation

struct TemperatureRange {
    var min: Float
    var max: Float
}

struct DayForecast: DatedForecast {
    var date: Date
    var sunriseTime: Date
    var sunsetTime: Date
    var temperatureRange: TemperatureRange
    var precipitationSum: Float
    var precipitationProbabilityMax: Int16
    var weatherCode: Weather.Code
}
