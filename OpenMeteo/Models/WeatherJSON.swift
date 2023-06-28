//
//  WeatherJSON.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

final class WeatherJSON: Decodable {
    
    private(set) var weather: Weather

    enum RootCodingKeys: String, CodingKey {
        case latitude
        case longitude
        case currentWeather = "current_weather"
        case hourly
        case daily
    }
    
    enum CurrentWeatherCodingKeys: String, CodingKey {
        case temperature
//        case windspeed
//        case winddirection
        case weathercode
//        case isDay = "isDay"
        case time
    }
    
    enum HourlyCodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weathercode
    }
    
    enum DailyCodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weathercode
        case temperatureMax = "temperature_2m_max"
        case temperatureMin = "temperature_2m_min"
        case sunrise
        case sunset
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        
        let currentWeatherContainer = try? rootContainer.nestedContainer(keyedBy: CurrentWeatherCodingKeys.self, forKey: .currentWeather)
        let time: Date = {
            guard let timeString = try? currentWeatherContainer?.decode(String.self, forKey: .time) else {
                return Date()
            }
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = .withInternetDateTime
            return dateFormatter.date(from: timeString + ":00+00:00") ?? Date()
        }()
        let temperature = try? currentWeatherContainer?.decode(Float.self, forKey: .temperature)
        let currentWeatherCode = try? currentWeatherContainer?.decode(Int16.self, forKey: .weathercode)
        let currentWeather = HourForecast(date: time, weatherCode: currentWeatherCode ?? 0, temperature: temperature ?? 0)
        
        let hourlyContainer = try? rootContainer.nestedContainer(keyedBy: HourlyCodingKeys.self, forKey: .hourly)
        
        var timeList: [Date?] = []
        if let timeStrings = try? hourlyContainer?.decode([String].self, forKey: .time) {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = .withInternetDateTime
            timeList = timeStrings.map { dateFormatter.date(from: $0 + ":00+00:00") }
        }

        let temperatureList = try? hourlyContainer?.decode([Float].self, forKey: .temperature)
        let weatherCodeList = try? hourlyContainer?.decode([Int16].self, forKey: .weathercode)
        
        var hourlyForecastList: [HourForecast] = []
        for i in 0 ..< timeList.count {
            guard let time = timeList[i],
                  let temperature = temperatureList?[i],
                  let weatherCode = weatherCodeList?[i] else { continue }
            hourlyForecastList.append(HourForecast(date: time, weatherCode: weatherCode, temperature: temperature))
        }
        
        let dailyContainer = try? rootContainer.nestedContainer(keyedBy: DailyCodingKeys.self, forKey: .daily)
        
        var dateList: [Date] = []
        if let dateStrings = try? dailyContainer?.decode([String].self, forKey: .time) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateList = dateStrings.map { dateFormatter.date(from: $0) ?? Date(timeIntervalSinceReferenceDate: 0) }
        }

        let dailyTemperatureMinList = try? dailyContainer?.decode([Float].self, forKey: .temperatureMin)
        let dailyTemperatureMaxList = try? dailyContainer?.decode([Float].self, forKey: .temperatureMax)
        let dailyWeatherCodeList = try? dailyContainer?.decode([Int16].self, forKey: .weathercode)
        let dailySunriseListString = try? dailyContainer?.decode([String].self, forKey: .sunrise)
        let dailySunsetListString = try? dailyContainer?.decode([String].self, forKey: .sunset)
        
        let sunriseDateList = dailySunriseListString?.compactMap({ dateString in
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = .withInternetDateTime
            return dateFormatter.date(from: dateString + ":00+00:00")
        })
        
        let sunsetDateList = dailySunsetListString?.compactMap({ dateString in
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = .withInternetDateTime
            return dateFormatter.date(from: dateString + ":00+00:00")
        })
        
        var dailyForecastList: [DayForecast] = []

        for index in 0 ..< dateList.count {
            let date = dateList[index]
            let sunriseTime = sunriseDateList?[index] ?? Date(timeIntervalSinceReferenceDate: 0)
            let sunsetTime = sunsetDateList?[index] ?? Date(timeIntervalSinceReferenceDate: 0)
            let minTemperature = dailyTemperatureMinList?[index] ?? 0
            let maxTemperature = dailyTemperatureMaxList?[index] ?? 0
            let weatherCode = dailyWeatherCodeList?[index] ?? 0

            let dailyForecast = DayForecast(
                date: date,
                sunriseTime: sunriseTime,
                sunsetTime: sunsetTime,
                weatherCode: weatherCode,
                minTemperature: minTemperature,
                maxTemperature: maxTemperature
            )
            dailyForecastList.append(dailyForecast)
        }

        self.weather = Weather(current: currentWeather, hourly: hourlyForecastList, daily: dailyForecastList)
    }
}
