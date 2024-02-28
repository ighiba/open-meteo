//
//  HourForecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct HourTemperature {
    var real: Float
    var apparent: Float
    var perception: TemperaturePerception { TemperaturePerception.compareTemperatures(real: real, apparent: apparent) }
}

struct HourForecast: DatedForecast {
    var date: Date
    var isDay: Bool
    var relativeHumidity: Int16
    var precipitationProbability: Int16
    var weatherCode: WeatherCode
    var wind: Wind
    var temperature: HourTemperature
    
    init() {
        self.init(date: Date(), isDay: true, relativeHumidity: 0, precipitationProbability: 0, weatherCode: .clearSky, wind: Wind(), temperature: 0, apparentTemperature: 0)
    }
    
    init(date: Date, isDay: Bool, relativeHumidity: Int16, precipitationProbability: Int16, weatherCode: WeatherCode, wind: Wind, temperature: Float, apparentTemperature: Float) {
        self.date = date
        self.isDay = isDay
        self.relativeHumidity = relativeHumidity
        self.precipitationProbability = precipitationProbability
        self.weatherCode = weatherCode
        self.wind = wind
        self.temperature = HourTemperature(real: temperature, apparent: apparentTemperature)
    }
}
