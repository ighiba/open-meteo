//
//  Weather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

private let oneHour: TimeInterval = 3600
private let fifteenMinutes: TimeInterval = 900

// MARK: - Weather

struct Weather {
    
    let lastUpdateTimestamp: Date
    
    fileprivate var currentHourForecast: HourForecast
    fileprivate var hourlyForecast: [HourForecast]
    fileprivate var dailyForecast: [DayForecast]
    
    init() {
        self.lastUpdateTimestamp = Date(timeIntervalSince1970: 0)
        self.currentHourForecast = HourForecast()
        self.hourlyForecast = []
        self.dailyForecast = []
    }
    
    init(current: HourForecast, hourly hourlyForecast: [HourForecast], daily dailyForecast: [DayForecast]) {
        self.lastUpdateTimestamp = Date()
        self.currentHourForecast = current
        self.hourlyForecast = hourlyForecast
        self.dailyForecast = dailyForecast
    }
}

// MARK: - Weather Service

protocol WeatherService {
    var weather: Weather { get set }
    var currentWeatherCode: Weather.Code { get }
    var currentWeatherCondition: Weather.Condition { get }
    var currentHourForecast: HourForecast { get }
    var currentDayForecast: DayForecast? { get }
    var currentDayTemperatureRange: TemperatureRange { get }
    var currentDayPhase: DayPhase { get }
    var currentSkyType: SkyType { get }
    init(weather: Weather)
    func isNeededWeatherUpdate() -> Bool
    func obtainHourlyForecast(forNextHours hours: UInt) -> [HourForecast]
    func obtainDailyForecast(forNextDays days: UInt) -> [DayForecast]
}

final class WeatherServiceImpl: WeatherService {
    
    // MARK: - Properties
    
    var weather: Weather
    
    var currentWeatherCode: Weather.Code { currentHourForecast.weatherCode }
    var currentWeatherCondition: Weather.Condition { currentWeatherCode.obtainWeatherCondition() }
    var currentHourForecast: HourForecast { obtainCurrentHourForecast() }
    var currentDayForecast: DayForecast? { obtainCurrentDayForecast() }
    var currentDayTemperatureRange: TemperatureRange { obtainCurrentDayTemperatureRange() }
    var currentDayPhase: DayPhase { obtainCurrentDayPhase() }
    var currentSkyType: SkyType { obtainCurrentSkyType() }
    
    // MARK: - Init
    
    init(weather: Weather) {
        self.weather = weather
    }
    
    // MARK: - Methods
    
    func isNeededWeatherUpdate() -> Bool {
        return weather.lastUpdateTimestamp.timeIntervalSinceNow <= -fifteenMinutes || weather.currentHourForecast.date.timeIntervalSinceNow <= -oneHour
    }
    
    func obtainHourlyForecast(forNextHours hours: UInt) -> [HourForecast] {
        return obtainForecastFromCurrentDate(weather.hourlyForecast, forNextItems: hours, toGranularity: .hour)
    }
    
    func obtainDailyForecast(forNextDays days: UInt) -> [DayForecast] {
        return obtainForecastFromCurrentDate(weather.dailyForecast, forNextItems: days, toGranularity: .day)
    }
    
    private func obtainCurrentHourForecast() -> HourForecast {
        if isDate(weather.currentHourForecast.date, equalToCurrent: .hour) {
            return weather.currentHourForecast
        } else {
            return obtainHourlyForecast(forNextHours: 24).first ?? weather.currentHourForecast // if outdated or offline
        }
    }
    
    private func obtainCurrentDayForecast() -> DayForecast? {
        return weather.dailyForecast.first { isDate($0.date, equalToCurrent: .day) }
    }
    
    private func obtainForecastFromCurrentDate<T: DatedForecast>(
        _ forecastList: [T],
        forNextItems items: UInt,
        toGranularity granularity: Calendar.Component
    ) -> [T] {
        let startIndex = forecastList.firstIndex { isDate($0.date, equalToCurrent: granularity) }
        guard let startIndex else { return [] }
        
        var endIndex = startIndex + Int(items)
        endIndex = forecastList.count <= endIndex ? forecastList.endIndex : endIndex
        let forecastListSlice = forecastList[startIndex...endIndex]
        
        return [T](forecastListSlice)
    }
    
    private func isDate(_ date: Date, equalToCurrent granularity: Calendar.Component) -> Bool {
        return Calendar.current.isDate(date, equalTo: Date(), toGranularity: granularity)
    }
    
    private func obtainCurrentDayTemperatureRange() -> TemperatureRange {
        return currentDayForecast?.temperatureRange ?? TemperatureRange(min: 0, max: 0)
    }
    
    private func obtainCurrentSkyType() -> SkyType {
        let dayPhase = obtainCurrentDayPhase()
        switch currentWeatherCondition {
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
    
    private func obtainCurrentDayPhase() -> DayPhase {
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
        return currentDayForecast?.sunriseTime.timeIntervalSinceNow
    }
    
    private func obtainSunsetOffset() -> TimeInterval? {
        return currentDayForecast?.sunsetTime.timeIntervalSinceNow
    }
    
    private func isAfterSunsetAndBeforeMidnight(_ sunriseOffset: TimeInterval, _ sunsetOffset: TimeInterval) -> Bool {
        return sunriseOffset < 0 && sunsetOffset < 0
    }
    
    private func isAfterMidnightAndBeforeSunrise(_ sunriseOffset: TimeInterval, _ sunsetOffset: TimeInterval) -> Bool {
        return sunriseOffset > 0 && sunsetOffset > 0
    }
}
