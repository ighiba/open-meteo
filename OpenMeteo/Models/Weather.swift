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
        if Calendar.current.isDate(current.date, equalTo: Date(), toGranularity: .hour) {
            return current
        } else {
            // if outdated or offline
            return obtainHourlyForecastForCurrentDay().first ?? current
        }
    }
    
    func obtainHourlyForecastForCurrentDay() -> [HourForecast] {
        return obtainForecastFromCurrentDate(forecastByHour, forNextItems: 24, toGranularity: .hour)
    }
    
    func obtainDailyForecastFor(nextDays days: UInt) -> [DayForecast] {
        return obtainForecastFromCurrentDate(forecastByDay, forNextItems: days, toGranularity: .day)
    }
    
    private func obtainForecastFromCurrentDate<T: DatedForecast>(
        _ forecastList: [T],
        forNextItems items: UInt,
        toGranularity: Calendar.Component
    ) -> [T] {
        if let startIndex = forecastList.firstIndex(where: { forecast in
            Calendar.current.isDate(forecast.date, equalTo: Date(), toGranularity: toGranularity)
        }) {
            var endIndex = startIndex + Int(items)
            endIndex = forecastList.count <= endIndex ? forecastList.count - 1 : endIndex
            let slice = forecastList[startIndex...endIndex]
            return [T](slice)
        }
        return []
    }
}


