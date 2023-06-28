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
    var weatherCode: Int16
    var minTemperature: Float
    var maxTemperature: Float
}
