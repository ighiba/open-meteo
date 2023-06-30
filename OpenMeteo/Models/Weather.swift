//
//  Weather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

enum DayPhase {
    case day
    case night
    case sunrise
    case sunset
    
    func obtainClearSkyType() -> SkyType {
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
    case partiallyCloudy
    case overcast
    case fog
    case drizzle
    case rain
    case rainHeavy
    case hail
    case snow
    case thunderstorm
}

private let oneHour: TimeInterval = 3600

struct Weather {
    
    // MARK: - Properties
    
    private var current: HourForecast
    private var hourlyForecast: [HourForecast]
    private var dailyForecast: [DayForecast]
    
    var currentWeatherCode: WeatherCode {
        return obtainForecastForCurrentHour().weatherCode
    }
    
    var currentWeatherType: WeatherType {
        return currentWeatherCode.obtainWeatherType()
    }
    
    var currentDayMinTemperature: Float {
        return obtainCurrentDayForecast()?.minTemperature ?? 0
    }
    
    var currentDayMaxTemperature: Float {
        return obtainCurrentDayForecast()?.maxTemperature ?? 0
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
        let day = dailyForecast.first(where: { forecast in
            Calendar.current.isDate(forecast.date, equalTo: Date(), toGranularity: .day)
        })
        return day
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
        let dayPhase = obtainCurrentDayPhase()
        switch currentWeatherType {
        case .clearSky:
            return dayPhase.obtainClearSkyType()
        case .partiallyCloudy:
            return dayPhase == .night ? .partiallyCloudyNight : .partiallyCloudyDay
        case .fog, .overcast, .drizzle:
            return .cloudy
        case .rain, .rainHeavy, .hail, .snow, .thunderstorm:
            return .rain
        }
    }

    func obtainCurrentDayPhase() -> DayPhase {
        if isSunriseNow() {
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
        guard let sunriseOffset = obtainSunriseOffset() else { return false }
        return (sunriseOffset <= oneHour) && (sunriseOffset >= -oneHour)
    }
    
    private func isSunsetNow() -> Bool {
        guard let sunsetOffset = obtainSunsetOffset() else { return false }
        return (sunsetOffset <= oneHour) && (sunsetOffset >= -oneHour)
    }
    
    private func isNightNow() -> Bool {
        guard let sunriseOffset = obtainSunriseOffset(), let sunsetOffset = obtainSunsetOffset() else { return false }
        return isAfterSunsetAndBeforeMidnight(sunriseOffset, sunsetOffset) ||
               isAfterMidnightAndBeforeSunrise(sunriseOffset, sunsetOffset)
    }
    
    private func obtainSunriseOffset() -> TimeInterval? {
        return obtainCurrentDayForecast()?.sunriseTime.timeIntervalSinceNow
    }
    
    private func obtainSunsetOffset() -> TimeInterval? {
        return obtainCurrentDayForecast()?.sunsetTime.timeIntervalSinceNow
    }
    
    private func isAfterSunsetAndBeforeMidnight(_ sunriseOffset: TimeInterval, _ sunsetOffset: TimeInterval) -> Bool {
        return sunriseOffset < 0 && sunsetOffset < 0
    }
    
    private func isAfterMidnightAndBeforeSunrise(_ sunriseOffset: TimeInterval, _ sunsetOffset: TimeInterval) -> Bool {
        return sunriseOffset > 0 && sunsetOffset > 0
    }
}
