//
//  Weather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct Weather {
    var current: HourForecast
    var forecastByHour: [HourForecast]
    var forecastByDay: [DayForecast]
    
    init(current: HourForecast, forecastByHour: [HourForecast]) {
        self.current = current
        self.forecastByHour = forecastByHour
        self.forecastByDay = DayForecast.transform(from: forecastByHour)
    }
}
