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
    }
    
    enum CurrentWeatherCodingKeys: String, CodingKey {
        case temperature
//        case windspeed
//        case winddirection
//        case weathercode
//        case isDay = "isDay"
        case time
    }
    
    enum HourlyCodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
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
        let currentWeather = TimedTemperature(time: time, temperature: temperature ?? 0)
        
        let hourlyContainer = try? rootContainer.nestedContainer(keyedBy: HourlyCodingKeys.self, forKey: .hourly)
        
        var timeList: [Date?] = []
        if let timeStrings = try? hourlyContainer?.decode([String].self, forKey: .time) {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = .withInternetDateTime
            timeList = timeStrings.map { dateFormatter.date(from: $0 + ":00+00:00") }
        }

        let temperatureList = try? hourlyContainer?.decode([Float].self, forKey: .temperature2m)
        
        var forecast: [TimedTemperature] = []
        for i in 0 ..< timeList.count {
            guard let time = timeList[i], let temperature = temperatureList?[i] else { continue }
            forecast.append(TimedTemperature(time: time, temperature: temperature))
        }

        self.weather = Weather(current: currentWeather, forecast: forecast)
    }
}
