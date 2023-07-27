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
        fetch(endpoint: endpoint, decodingType: WeatherJSON.self, completion: completion)
    }
    
    func fetchSearchResults(endpoint: API.Search, completion: @escaping (FetchSearchResult) -> Void) {
        fetch(endpoint: endpoint, decodingType: GeocodingJSON.self, completion: completion)
    }
    
    private func fetch<T>(endpoint: Endpoint, decodingType: any DecodableResult<T>.Type, completion: @escaping (Result<T, FetchError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.urlError))
            return
        }
        
        session.dataTask(with: url) { [weak self] data, response, error in
            var result: Result<T, FetchError>
            
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
                guard let decodedJson = try? strongSelf.decoder.decode(decodingType, from: parsData) else {
                    result = .failure(.decodeError)
                    return
                }
                result = .success(decodedJson.result)
            } else {
                result = .failure(.unknown)
            }
        }.resume()
    }
}
