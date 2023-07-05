//
//  GeoWeatherDetailViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import Foundation
import Combine

protocol GeoWeatherDetailViewModelDelegate: AnyObject {
    var geoWeather: GeoWeather! { get }
    var geoWeatherDidChangedHandler: ((GeoWeather) -> Void)? { get set }
    func updateWeather(forcedUpdate: Bool)
}

class GeoWeatherDetailViewModel: GeoWeatherDetailViewModelDelegate {
    
    // MARK: - Properties
    
    var geoWeather: GeoWeather! {
        didSet {
            geoWeatherDidChangedHandler?(geoWeather)
        }
    }
    
    var geoWeatherDidChangedHandler: ((GeoWeather) -> Void)?
    
    var networkManager: NetworkManager!
    
    var weatherCancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    func updateWeather(forcedUpdate: Bool) {
        return
        guard needUpdate(for: geoWeather.weather) || forcedUpdate else { return }
        
        weatherCancellables.forEach { $0.cancel() }
        weatherCancellables.removeAll()
        
        fetchWeatherPublisher(geocoding: geoWeather.geocoding)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] weather in
                self?.geoWeather.weather = weather
                self?.geoWeatherDidChangedHandler?((self?.geoWeather)!)
            }
            .store(in: &weatherCancellables)
    }
    
    private func needUpdate(for weather: Weather?) -> Bool {
        guard let weather = weather else { return true }
        print(weather.lastUpdateTimestamp.timeIntervalSinceNow)
        return weather.isNeededUpdate()
    }
    
    private func fetchWeatherPublisher(geocoding: Geocoding) -> AnyPublisher<Weather, FetchErorr> {
        return Future<Weather, FetchErorr> { [weak self] promise in
            self?.networkManager.fetchWeather(for: geocoding) { result in
                switch result {
                case .success(let weather):
                    promise(.success(weather))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

