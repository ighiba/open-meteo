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
    
    func obtainForecastForCurrentHour() -> HourForecast {
        if Calendar.current.isDate(current.time, equalTo: Date(), toGranularity: .hour) {
            return current
        } else {
            // if outdated or offline
            return obtainHourlyForecastForCurrentDay().first ?? current
        }
    }
    
    func obtainHourlyForecastForCurrentDay() -> [HourForecast] {
        if let startIndex = forecastByHour.firstIndex(where: { forecast in
            Calendar.current.isDate(forecast.time, equalTo: Date(), toGranularity: .hour)
        }) {
            var endIndex = startIndex + 24
            endIndex = forecastByHour.count < endIndex ? forecastByHour.count - 1 : endIndex
            let slice = forecastByHour[startIndex...endIndex]
            return [HourForecast](slice)
        }

        return []
    }
}
