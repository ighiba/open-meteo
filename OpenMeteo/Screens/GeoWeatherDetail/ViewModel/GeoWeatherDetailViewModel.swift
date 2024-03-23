//
//  GeoWeatherDetailViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import Foundation
import Combine

protocol GeoWeatherDetailViewModelDelegate: AnyObject {
    var geoWeather: GeoWeather { get }
    var geoWeatherPublisher: Published<GeoWeather>.Publisher { get }
    var networkErrorPublisher: PassthroughSubject<FetchError, Never> { get }
    func updateWeather(forcedUpdate: Bool)
    func weatherService(forWeather weather: Weather) -> WeatherService
}

final class GeoWeatherDetailViewModel: GeoWeatherDetailViewModelDelegate {
    
    // MARK: - Properties
    
    @Published var geoWeather: GeoWeather
    var geoWeatherPublisher: Published<GeoWeather>.Publisher { $geoWeather }
    var networkErrorPublisher: PassthroughSubject<FetchError, Never> = PassthroughSubject()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkManager: NetworkManager
    
    // MARK: - Init
    
    init(geoWeather: GeoWeather, networkManager: NetworkManager, weatherServiceType: WeatherService.Type) {
        self.geoWeather = geoWeather
        self.networkManager = networkManager
        self.weatherServiceType = weatherServiceType
    }

    // MARK: - Methods
    
    func updateWeather(forcedUpdate: Bool) {
        guard isUpdateNeeded(for: geoWeather.weather) || forcedUpdate else { return }
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        fetchWeatherPublisher(geocoding: geoWeather.geocoding)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    self?.networkErrorPublisher.send(error)
                }
            } receiveValue: { [weak self] weather in
                self?.geoWeather.weather = weather
            }
            .store(in: &cancellables)
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
    
    private func isUpdateNeeded(for weather: Weather) -> Bool {
        return weatherService(forWeather: weather).isNeededWeatherUpdate()
    }
    
    func weatherService(forWeather weather: Weather) -> WeatherService {
        return weatherServiceType.init(weather: weather)
    }
}
