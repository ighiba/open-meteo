//
//  NetworkManager.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 04.07.2023.
//

import Foundation

enum FetchSearchResult {
    case success(geocodingList: [Geocoding])
    case failure(error: FetchError)
}

enum FetchWeatherResult {
    case success(weather: Weather)
    case failure(error: FetchError)
}

protocol NetworkManager: AnyObject {
    func fetchWeather(for geocoding: Geocoding, completion: @escaping (FetchWeatherResult) -> Void)
    func fetchSearchResults(for searchString: String, completion: @escaping (FetchSearchResult) -> Void)
}

class NetworkManagerImpl: NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private let validCodes = 200...299
    
    private let forecastDays = 10
    
    private let hourlyQuery = [
        "temperature_2m",
        "relativehumidity_2m",
        "apparent_temperature",
        "precipitation_probability",
        "weathercode",
        "windspeed_10m",
        "winddirection_10m",
        "is_day"
    ]
    
    private let dailyQuery = [
        "weathercode",
        "temperature_2m_max",
        "temperature_2m_min",
        "sunrise",
        "sunset",
        "precipitation_sum",
        "precipitation_probability_max"
    ]
    
    func fetchWeather(for geocoding: Geocoding, completion: @escaping (FetchWeatherResult) -> Void) {
        let forecastUrlSearch = URL(string: "https://api.open-meteo.com/v1/forecast")?.appending(params: [
            "latitude"        : "\(geocoding.latitude)",
            "longitude"       : "\(geocoding.longitude)",
            "hourly"          : hourlyQuery.joined(separator: ","),
            "daily"           : dailyQuery.joined(separator: ","),
            "forecast_days"    : "\(forecastDays)",
            "current_weather"  : "true",
            "timezone"         : "GMT"
        ])
        
        guard let url = forecastUrlSearch else {
            completion(.failure(error: .urlError))
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            var result: FetchWeatherResult

            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let strongSelf = self else {
                result = .failure(error: .unknown)
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                result = .failure(error: .unknown)
                return
            }
            
            guard strongSelf.validCodes.contains(httpUrlResponse.statusCode) else {
                result = .failure(error: .networkError(statusCode: httpUrlResponse.statusCode))
                return
            }
            
            if error == nil, let parsData = data  {
                guard let weatherJson = try? strongSelf.decoder.decode(WeatherJSON.self, from: parsData) else {
                    result = .failure(error: .decodeError)
                    return
                }
                result = .success(weather: weatherJson.weather)
            } else {
                result = .failure(error: .unknown)
            }
        }.resume()
    }
    
    func fetchSearchResults(for searchString: String, completion: @escaping (FetchSearchResult) -> Void) {
        guard let queryString = encodeQueryParameter(searchString) else {
            completion(.failure(error: .stringQueryError))
            return
        }
        
        let geocodingUrlSearch = URL(string: "https://geocoding-api.open-meteo.com/v1/search")?.appending(params: [
            "name"    : queryString,
            "count"   : "10",
            "language": Locale.current.languageCode ?? "en",
            "format"  : "json"
        ])
        
        guard let url = geocodingUrlSearch else {
            completion(.failure(error: .urlError))
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            var result: FetchSearchResult
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            guard let strongSelf = self else {
                result = .success(geocodingList: [])
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                result = .failure(error: .unknown)
                return
            }
            
            guard strongSelf.validCodes.contains(httpUrlResponse.statusCode) else {
                result = .failure(error: .networkError(statusCode: httpUrlResponse.statusCode))
                return
            }
            
            if error == nil, let parsData = data  {
                guard let geocodingJson = try? strongSelf.decoder.decode(GeocodingJSON.self, from: parsData) else {
                    result = .failure(error: .decodeError)
                    return
                }
                result = .success(geocodingList: geocodingJson.geocodingList)
            } else {
                result = .failure(error: .unknown)
            }
        }.resume()
    }
    
    private func encodeQueryParameter(_ parameter: String) -> String? {
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        return parameter.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}


