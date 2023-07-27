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
    var geoWeatherDidChangeHandler: ((GeoWeather) -> Void)? { get set }
    var networkErrorHasOccurredHandler: (() -> Void)? { get set }
    func updateWeather(forcedUpdate: Bool)
}

class GeoWeatherDetailViewModel: GeoWeatherDetailViewModelDelegate {
    
    // MARK: - Properties
    
    var geoWeather: GeoWeather! {
        didSet {
            geoWeatherDidChangeHandler?(geoWeather)
        }
    }
    
    var geoWeatherDidChangeHandler: ((GeoWeather) -> Void)?
    var networkErrorHasOccurredHandler: (() -> Void)?
    
    var networkManager: NetworkManager!
    
    var weatherCancellables = Set<AnyCancellable>()
    
    // MARK: - Methods
    
    func updateWeather(forcedUpdate: Bool) {
        guard needUpdate(for: geoWeather.weather) || forcedUpdate else { return }
        
        weatherCancellables.forEach { $0.cancel() }
        weatherCancellables.removeAll()
        
        fetchWeatherPublisher(geocoding: geoWeather.geocoding)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.networkErrorHasOccurredHandler?()
                }
            } receiveValue: { [weak self] weather in
                self?.geoWeather.weather = weather
                guard let geoWeather = self?.geoWeather else { return }
                self?.geoWeatherDidChangeHandler?(geoWeather)
            }
            .store(in: &weatherCancellables)
    }
    
    private func needUpdate(for weather: Weather?) -> Bool {
        guard let weather = weather else { return true }
        return weather.isNeededUpdate()
    }
    
    private func fetchWeatherPublisher(geocoding: Geocoding) -> AnyPublisher<Weather, FetchError> {
        return Future<Weather, FetchError> { [weak self] promise in
            self?.networkManager.fetchWeather(endpoint: .standart(geocoding: geocoding)) { result in
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

