//
//  HourForecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct HourForecast: DatedForecast {
    var date: Date
    var isDay: Bool
    var precipitationProbability: Int16
    var weatherCode: WeatherCode
    var wind: Wind
    var temperature: Float
    var apparentTemperature: Float
}
