//
//  NetworkManager.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 04.07.2023.
//

import Foundation

typealias FetchSearchResult = Result<[Geocoding], FetchError>
typealias FetchWeatherResult = Result<Weather, FetchError>

protocol NetworkManager: AnyObject {
    func fetchWeather(endpoint: API.Forecast, completion: @escaping (FetchWeatherResult) -> Void)
    func fetchSearchResults(endpoint: API.Search, completion: @escaping (FetchSearchResult) -> Void)
}

class NetworkManagerImpl: NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private let validCodes = 200...299
    
    func fetchWeather(endpoint: API.Forecast, completion: @escaping (FetchWeatherResult) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.urlError))
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
                result = .failure(.unknown)
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                result = .failure(.unknown)
                return
            }
            
            guard strongSelf.validCodes.contains(httpUrlResponse.statusCode) else {
                result = .failure(.networkError(statusCode: httpUrlResponse.statusCode))
                return
            }
            
            if error == nil, let parsData = data  {
                guard let weatherJson = try? strongSelf.decoder.decode(WeatherJSON.self, from: parsData) else {
                    result = .failure(.decodeError)
                    return
                }
                result = .success(weatherJson.weather)
            } else {
                result = .failure(.unknown)
            }
        }.resume()
    }
    
    func fetchSearchResults(endpoint: API.Search, completion: @escaping (FetchSearchResult) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.urlError))
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
                result = .success([])
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else {
                result = .failure(.unknown)
                return
            }
            
            guard strongSelf.validCodes.contains(httpUrlResponse.statusCode) else {
                result = .failure(.networkError(statusCode: httpUrlResponse.statusCode))
                return
            }
            
            if error == nil, let parsData = data  {
                guard let geocodingJson = try? strongSelf.decoder.decode(GeocodingJSON.self, from: parsData) else {
                    result = .failure(.decodeError)
                    return
                }
                result = .success(geocodingJson.geocodingList)
            } else {
                result = .failure(.unknown)
            }
        }.resume()
    }
}
