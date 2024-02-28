//
//  DayForecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import Foundation

struct DayForecast: DatedForecast {
    var date: Date
    var sunriseTime: Date
    var sunsetTime: Date
    var minTemperature: Float
    var maxTemperature: Float
    var precipitationSum: Float
    var precipitationProbabilityMax: Int16
    var weatherCode: WeatherCode
}
