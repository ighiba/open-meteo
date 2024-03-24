//
//  NetworkManager.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 04.07.2023.
//

import Foundation
import Combine

protocol NetworkManager: AnyObject {
    func fetchWeather(endpoint: API.Forecast) -> Future<Weather, FetchError>
    func fetchSearchResults(endpoint: API.Search) -> Future<[Geocoding], FetchError>
}

final class NetworkManagerImpl: NetworkManager {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private let validCodes = 200...299
    
    func fetchWeather(endpoint: API.Forecast) -> Future<Weather, FetchError> {
        return fetch(endpoint: endpoint, decodingType: WeatherJSON.self)
    }
    
    func fetchSearchResults(endpoint: API.Search) -> Future<[Geocoding], FetchError> {
        return fetch(endpoint: endpoint, decodingType: GeocodingJSON.self)
    }
    
    private func fetch<T>(endpoint: Endpoint, decodingType: any DecodableResult<T>.Type) -> Future<T, FetchError> {
        return Future { [weak self] promise in
            self?.fetch(endpoint: endpoint, decodingType: decodingType, completion: { result in
                switch result {
                case .success(let resultData):
                    promise(.success(resultData))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }
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
