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
        case hourly
    }
    
    enum HourlyCodingKeys: String, CodingKey {
        case time
        case temperature_2m
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let hourlyContainer = try? rootContainer.nestedContainer(keyedBy: HourlyCodingKeys.self, forKey: .hourly)
        
        var timeList: [Date?] = []
        if let timeStrings = try? hourlyContainer?.decode([String].self, forKey: .time) {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = .withInternetDateTime
            timeList = timeStrings.map { dateFormatter.date(from: $0 + ":00+00:00") }
        }

        let temperatureList = try? hourlyContainer?.decode([Float].self, forKey: .temperature_2m)
        
        var timedTemperatureList: [TimedTemperature] = []
        for i in 0 ..< timeList.count {
            guard let time = timeList[i], let temperature = temperatureList?[i] else { continue }
            timedTemperatureList.append(TimedTemperature(time: time, temperature: temperature))
        }

        self.weather = Weather(timedTemperatureList: timedTemperatureList)
    }
}
