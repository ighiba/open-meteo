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
    var temperature: HourTemperature
    var relativeHumidity: Int16
    var precipitationProbability: Int16
    var wind: Wind
    var weatherCode: WeatherCode
    
    init() {
        self.init(date: Date(), isDay: true, temperature: HourTemperature(real: 0, apparent: 0), relativeHumidity: 0, precipitationProbability: 0, wind: Wind(), weatherCode: .clearSky)
    }
    
    init(date: Date, isDay: Bool, temperature: HourTemperature, relativeHumidity: Int16, precipitationProbability: Int16, wind: Wind, weatherCode: WeatherCode) {
        self.date = date
        self.isDay = isDay
        self.temperature = temperature
        self.relativeHumidity = relativeHumidity
        self.precipitationProbability = precipitationProbability
        self.wind = wind
        self.weatherCode = weatherCode
    }
}
