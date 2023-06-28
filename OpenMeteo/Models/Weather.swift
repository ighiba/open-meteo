//
//  Weather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct Weather {
    private var current: HourForecast
    private var hourlyForecast: [HourForecast]
    private var dailyForecast: [DayForecast]
    
    init(current: HourForecast, hourly hourlyForecast: [HourForecast], daily dailyForecast: [DayForecast]) {
        self.current = current
        self.hourlyForecast = hourlyForecast
        self.dailyForecast = dailyForecast
    }
    
    func obtainWeatherTypeForCurrentHour() -> WeatherType {
        var weatherCode: Int16
        if Calendar.current.isDate(current.date, equalTo: Date(), toGranularity: .hour) {
            weatherCode = current.weatherCode
        } else {
            // if outdated or offline
            weatherCode = obtainForecastForCurrentHour().weatherCode
        }

        return WeatherCode(rawValue: weatherCode)?.obtainWeatherType() ?? .clearSky
    }
    
    func obtainForecastForCurrentHour() -> HourForecast {
        if Calendar.current.isDate(current.date, equalTo: Date(), toGranularity: .hour) {
            return current
        } else {
            // if outdated or offline
            return obtainHourlyForecastFor(nextHours: 24).first ?? current
        }
    }
    
    func obtainHourlyForecastFor(nextHours hours: UInt) -> [HourForecast] {
        return obtainForecastFromCurrentDate(hourlyForecast, forNextItems: hours, toGranularity: .hour)
    }
    
    func obtainDailyForecastFor(nextDays days: UInt) -> [DayForecast] {
        return obtainForecastFromCurrentDate(dailyForecast, forNextItems: days, toGranularity: .day)
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
    
    func obtainCurrentDayForecast() -> DayForecast? {
        return obtainDailyForecastFor(nextDays: 1).first
    }
    
    func isSunriseNow() -> Bool {
        guard let today = obtainCurrentDayForecast() else { return false }
        let sunriseOffset = today.sunriseTime.timeIntervalSinceNow
        
        return (sunriseOffset <= 3600) && (sunriseOffset >= -3600)
    }
    
    func isSunsetNow() -> Bool {
        guard let today = obtainCurrentDayForecast() else { return false }
        let sunsetOffset = today.sunsetTime.timeIntervalSinceNow
        
        return (sunsetOffset <= 3600) && (sunsetOffset >= -3600)
    }
    
    func isNightNow() -> Bool {
        guard let today = obtainCurrentDayForecast() else { return false }
        let sunriseOffset = today.sunriseTime.timeIntervalSinceNow
        let sunsetOffset = today.sunsetTime.timeIntervalSinceNow

        return (sunriseOffset > 0 && sunsetOffset < 0) || (sunriseOffset < 0 && sunsetOffset < 0)
    }
}


