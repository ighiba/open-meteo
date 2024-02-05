//
//  WeatherJSON.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

final class WeatherJSON: DecodableResult {
    
    typealias T = Weather
    
    var result: Weather = Weather()
    
    private let dateTimeFormatter = ISO8601DateFormatter(formatOptions: .withInternetDateTime)
    private let dateFormatter = DateFormatter(format: "yyyy-MM-dd")
    
    // MARK: - CodingKeys

    enum RootCodingKeys: String, CodingKey {
        case latitude
        case longitude
        case currentWeather = "current_weather"
        case hourly
        case daily
    }
    
    enum CurrentWeatherCodingKeys: String, CodingKey {
        case temperature
        case windSpeed = "windspeed"
        case windDirection = "winddirection"
        case weathercode
        case isDay = "is_day"
        case time
    }
    
    enum HourlyCodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity = "relativehumidity_2m"
        case precipitationProbability = "precipitation_probability"
        case weathercode
        case windSpeed = "windspeed_10m"
        case windDirection = "winddirection_10m"
        case isDay = "is_day"
    }
    
    enum DailyCodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weathercode
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case sunrise
        case sunset
        case precipitationSum = "precipitation_sum"
        case precipitationProbabilityMax = "precipitation_probability_max"
    }
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        
        var currentWeather = decodeCurrentWeather(inRoot: rootContainer)
        let hourlyForecastList = decodeHourlyForecast(inRoot: rootContainer)
        let dailyForecastList = decodeDailyForecast(inRoot: rootContainer)
        
        // because api doesn't provide this values for current
        let currentHour = hourlyForecastList.first { $0.date == currentWeather.date }
        currentWeather.relativeHumidity = currentHour?.relativeHumidity ?? 0
        currentWeather.apparentTemperature = currentHour?.apparentTemperature ?? 0

        self.result = Weather(current: currentWeather, hourly: hourlyForecastList, daily: dailyForecastList)
    }
    
    // MARK: - Methods
    
    private func decodeCurrentWeather(inRoot rootContainer: KeyedDecodingContainer<WeatherJSON.RootCodingKeys>) -> HourForecast {
        let currentWeatherContainer = try? rootContainer.nestedContainer(keyedBy: CurrentWeatherCodingKeys.self, forKey: .currentWeather)
        let dateTime: Date = {
            guard let dateTimeString = try? currentWeatherContainer?.decode(String.self, forKey: .time) else { return Date() }
            return convertDateTimeStringIntoDate(dateTimeString) ?? Date()
        }()
        let isDay = try? currentWeatherContainer?.decode(Int.self, forKey: .isDay)
        let temperature = try? currentWeatherContainer?.decode(Float.self, forKey: .temperature)
        let weatherCodeRaw = try? currentWeatherContainer?.decode(Int16.self, forKey: .weathercode)
        let weatherCode = WeatherCode(rawValue: weatherCodeRaw ?? 0) ?? .clearSky
        let windSpeed = try? currentWeatherContainer?.decode(Float.self, forKey: .windSpeed)
        let windDirection = try? currentWeatherContainer?.decode(Int16.self, forKey: .windDirection)
        let wind = Wind(speed: windSpeed ?? 0, direction: windDirection ?? 0)

        return HourForecast(
            date: dateTime,
            isDay: isDay != 0,
            relativeHumidity: 0,
            precipitationProbability: 0,
            weatherCode: weatherCode,
            wind: wind,
            temperature: temperature ?? 0,
            apparentTemperature: 0
        )
    }
    
    private func decodeHourlyForecast(inRoot rootContainer: KeyedDecodingContainer<WeatherJSON.RootCodingKeys>) -> [HourForecast] {
        let hourlyContainer = try? rootContainer.nestedContainer(keyedBy: HourlyCodingKeys.self, forKey: .hourly)
        
        var dateTimeList: [Date] = []
        if let dateTimeStrings = try? hourlyContainer?.decode([String].self, forKey: .time) {
            dateTimeList = dateTimeStrings.map { convertDateTimeStringIntoDate($0) ?? Date(timeIntervalSinceReferenceDate: 0) }
        }

        let isDayList = try? hourlyContainer?.decode([Int].self, forKey: .isDay)
        let temperatureList = try? hourlyContainer?.decode([Float].self, forKey: .temperature)
        let relativeHumidityList = try? hourlyContainer?.decode([Int16].self, forKey: .relativeHumidity)
        let precipitationProbabilityList = try? hourlyContainer?.decode([Int16].self, forKey: .precipitationProbability)
        let weatherCodeList = try? hourlyContainer?.decode([Int16].self, forKey: .weathercode)
        let windSpeedList = try? hourlyContainer?.decode([Float].self, forKey: .windSpeed)
        let windDirectionList = try? hourlyContainer?.decode([Int16].self, forKey: .windDirection)
        let apparentTemperatureList = try? hourlyContainer?.decode([Float].self, forKey: .apparentTemperature)
        
        var hourlyForecastList: [HourForecast] = []
        for index in 0 ..< dateTimeList.count {
            let dateTime = dateTimeList[index]
            let isDay = isDayList?[index]
            let temperature = temperatureList?[index] ?? 0
            let relativeHumidity = relativeHumidityList?[index] ?? 0
            let precipitationProbability = precipitationProbabilityList?[index] ?? 0
            let weatherCodeRaw = weatherCodeList?[index] ?? 0
            let weatherCode = WeatherCode(rawValue: weatherCodeRaw) ?? .clearSky
            let windSpeed = windSpeedList?[index] ?? 0
            let windDirection = windDirectionList?[index] ?? 0
            let wind = Wind(speed: windSpeed, direction: windDirection)
            let apparentTemperature = apparentTemperatureList?[index] ?? temperature
            
            let hourlyForecast = HourForecast(
                date: dateTime,
                isDay: isDay != 0,
                relativeHumidity: relativeHumidity,
                precipitationProbability: precipitationProbability,
                weatherCode: weatherCode,
                wind: wind,
                temperature: temperature,
                apparentTemperature: apparentTemperature
            )
            hourlyForecastList.append(hourlyForecast)
        }
        
        return hourlyForecastList
    }
    
    private func decodeDailyForecast(inRoot rootContainer: KeyedDecodingContainer<WeatherJSON.RootCodingKeys>) -> [DayForecast] {
        let dailyContainer = try? rootContainer.nestedContainer(keyedBy: DailyCodingKeys.self, forKey: .daily)
        
        var dateList: [Date] = []
        if let dateStrings = try? dailyContainer?.decode([String].self, forKey: .time) {
            dateList = dateStrings.map { convertDateStringIntoDate($0) ?? Date(timeIntervalSinceReferenceDate: 0) }
        }

        let dailyTemperatureMinList = try? dailyContainer?.decode([Float].self, forKey: .temperatureMin)
        let dailyTemperatureMaxList = try? dailyContainer?.decode([Float].self, forKey: .temperatureMax)
        let dailyWeatherCodeList = try? dailyContainer?.decode([Int16].self, forKey: .weathercode)
        let dailySunriseListString = try? dailyContainer?.decode([String].self, forKey: .sunrise)
        let dailySunsetListString = try? dailyContainer?.decode([String].self, forKey: .sunset)
        let dailyPrecipitationSumList = try? dailyContainer?.decode([Float].self, forKey: .precipitationSum)
        let dailyPrecipitationProbabilityMaxList = try? dailyContainer?.decode([Int16].self, forKey: .precipitationProbabilityMax)

        let sunriseDateTimeList = dailySunriseListString?.compactMap { convertDateTimeStringIntoDate($0) }
        let sunsetDateTimeList = dailySunsetListString?.compactMap { convertDateTimeStringIntoDate($0) }
        
        var dailyForecastList: [DayForecast] = []

        for index in 0 ..< dateList.count {
            let date = dateList[index]
            let sunriseTime = sunriseDateTimeList?[index] ?? Date(timeIntervalSinceReferenceDate: 0)
            let sunsetTime = sunsetDateTimeList?[index] ?? Date(timeIntervalSinceReferenceDate: 0)
            let weatherCodeRaw = dailyWeatherCodeList?[index] ?? 0
            let weatherCode = WeatherCode(rawValue: weatherCodeRaw) ?? .clearSky
            let minTemperature = dailyTemperatureMinList?[index] ?? 0
            let maxTemperature = dailyTemperatureMaxList?[index] ?? 0
            let precipitationSum = dailyPrecipitationSumList?[index] ?? 0
            let precipitationProbabilityMax = dailyPrecipitationProbabilityMaxList?[index] ?? 0

            let dailyForecast = DayForecast(
                date: date,
                sunriseTime: sunriseTime,
                sunsetTime: sunsetTime,
                weatherCode: weatherCode,
                minTemperature: minTemperature,
                maxTemperature: maxTemperature,
                precipitationSum: precipitationSum,
                precipitationProbabilityMax: precipitationProbabilityMax
            )
            dailyForecastList.append(dailyForecast)
        }
        
        return dailyForecastList
    }
    
    private func convertDateTimeStringIntoDate(_ dateTimeString: String) -> Date? {
        return dateTimeFormatter.date(from: dateTimeString + ":00+00:00")
    }
    
    private func convertDateStringIntoDate(_ dateString: String) -> Date? {
        return dateFormatter.date(from: dateString)
    }
}
