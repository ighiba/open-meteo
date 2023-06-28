//
//  Weather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

// MARK: - Enums

enum DayPhase {
    case day
    case night
    case sunrise
    case sunset
    
    func obtainSkyType() -> SkyType {
        switch self {
        case .day:     return .day
        case .night:   return .night
        case .sunrise: return .sunrise
        case .sunset:  return .sunset
        }
    }
}

enum WeatherType {
    case clearSky
    case cloudly
    case fog
    case rain
    case snow
    case thunderstorm
}

struct Weather {
    
    // MARK: - Properties
    
    private var current: HourForecast
    private var hourlyForecast: [HourForecast]
    private var dailyForecast: [DayForecast]
    
    private let oneHour: TimeInterval = 3600
    
    var currentWeatherCode: WeatherCode {
        let weatherCode = obtainForecastForCurrentHour().weatherCode
        return WeatherCode(rawValue: weatherCode) ?? .clearSky
    }
    
    var currentWeatherType: WeatherType {
        return currentWeatherCode.obtainWeatherType()
    }
    
    // MARK: - Init
    
    init(current: HourForecast, hourly hourlyForecast: [HourForecast], daily dailyForecast: [DayForecast]) {
        self.current = current
        self.hourlyForecast = hourlyForecast
        self.dailyForecast = dailyForecast
    }
    
    // MARK: - Methods
    
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
    
    func obtainCurrentDayForecast() -> DayForecast? {
        return obtainDailyForecastFor(nextDays: 1).first
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
    
    func obtainSkyType() -> SkyType {
        switch currentWeatherType {
        case .clearSky:
            return obtainCurrentDayPhase().obtainSkyType()
        case .fog, .cloudly:
            return .cloudy
        case .rain, .snow, .thunderstorm:
            return .rain
        }
    }
    
    func obtainCurrentDayPhase() -> DayPhase {
        if isSunsetNow() {
            return .sunrise
        } else if isSunsetNow() {
            return .sunset
        } else if isNightNow() {
            return .night
        } else {
            return .day
        }
    }
    
    private func isSunriseNow() -> Bool {
        guard let today = obtainCurrentDayForecast() else { return false }
        let sunriseOffset = today.sunriseTime.timeIntervalSinceNow
        
        return (sunriseOffset <= oneHour) && (sunriseOffset >= -oneHour)
    }
    
    private func isSunsetNow() -> Bool {
        guard let today = obtainCurrentDayForecast() else { return false }
        let sunsetOffset = today.sunsetTime.timeIntervalSinceNow
        
        return (sunsetOffset <= oneHour) && (sunsetOffset >= -oneHour)
    }
    
    private func isNightNow() -> Bool {
        guard let today = obtainCurrentDayForecast() else { return false }
        let sunriseOffset = today.sunriseTime.timeIntervalSinceNow
        let sunsetOffset = today.sunsetTime.timeIntervalSinceNow

        return (sunriseOffset > 0 && sunsetOffset < 0) || (sunriseOffset < 0 && sunsetOffset < 0)
    } 
}



