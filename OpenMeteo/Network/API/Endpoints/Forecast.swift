//
//  Forecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 27.07.2023.
//

import Foundation

private let currentWeatherQuery = [
    "is_day",
    "temperature_2m",
    "apparent_temperature",
    "relative_humidity_2m",
    "wind_speed_10m",
    "wind_direction_10m",
    "weather_code"
]

private let hourlyQuery = [
    "is_day",
    "temperature_2m",
    "apparent_temperature",
    "relativehumidity_2m",
    "precipitation_probability",
    "windspeed_10m",
    "winddirection_10m",
    "weathercode",
]

private let dailyQuery = [
    "sunrise",
    "sunset",
    "temperature_2m_min",
    "temperature_2m_max",
    "precipitation_sum",
    "precipitation_probability_max",
    "weathercode"
]

extension API {
    enum Forecast: Endpoint {
        case standart(geocoding: Geocoding)
        
        var baseUrl: URL { URL(string: "https://api.open-meteo.com")! }
        
        var path: String {
            var path = "/v1"
            switch self {
            case .standart(_):
                path.append("/forecast")
            }
            return path
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case .standart(let geocoding):
                return [
                    URLQueryItem(name: "latitude", value: "\(geocoding.latitude)"),
                    URLQueryItem(name: "longitude", value: "\(geocoding.longitude)"),
                    URLQueryItem(name: "current", value: currentWeatherQuery.joined(separator: ",")),
                    URLQueryItem(name: "hourly", value: hourlyQuery.joined(separator: ",")),
                    URLQueryItem(name: "daily", value: dailyQuery.joined(separator: ",")),
                    URLQueryItem(name: "forecast_days", value: "\(10)"),
                    URLQueryItem(name: "timezone", value: "GMT"),
                ]
            }
        }
    }
}
