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
    func fetchSearchResults(for searchString: String, completion: @escaping (FetchSearchResult) -> Void)
    func fetchWeather(for geocoding: Geocoding, completion: @escaping (FetchWeatherResult) -> Void)
}

class NetworkManagerImpl: NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private let validCodes = 200...299
    
    func fetchSearchResults(for searchString: String, completion: @escaping (FetchSearchResult) -> Void) {
        guard let queryString = encodeQueryParameter(searchString) else {
            completion(.failure(error: .stringQueryError))
            return
        }
        
        var geocodingUrlSearch = URL(string: "https://geocoding-api.open-meteo.com/v1/search")
        let language = Locale.current.languageCode ?? "en"
        geocodingUrlSearch = geocodingUrlSearch?.appending(params: [
            "name"    : queryString,
            "count"   : "10",
            "language": language,
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
            guard let response = response as? HTTPURLResponse, strongSelf.validCodes.contains(response.statusCode) else {
                result = .failure(error: .networkError(statusCode: 404))
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
    
    func fetchWeather(for geocoding: Geocoding, completion: @escaping (FetchWeatherResult) -> Void) {
        let hourlyQuery = "temperature_2m,relativehumidity_2m,apparent_temperature,precipitation_probability,weathercode,windspeed_10m,winddirection_10m,is_day"
        let dailyQuery = "weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,precipitation_probability_max"

        var forecastUrlSearch = URL(string: "https://api.open-meteo.com/v1/forecast")
        forecastUrlSearch = forecastUrlSearch?.appending(params: [
            "latitude"        : "\(geocoding.latitude)",
            "longitude"       : "\(geocoding.longitude)",
            "hourly"          : hourlyQuery,
            "daily"           : dailyQuery,
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
            guard let response = response as? HTTPURLResponse, strongSelf.validCodes.contains(response.statusCode) else {
                result = .failure(error: .networkError(statusCode: 404))
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
    
    private func encodeQueryParameter(_ parameter: String) -> String? {
        let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        return parameter.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}


