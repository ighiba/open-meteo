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
    private let weatherServiceType: WeatherService.Type
    
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
        
        networkManager.fetchWeather(endpoint: .standart(geocoding: geoWeather.geocoding))
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Weather update error: \(error)")
                    self?.networkErrorPublisher.send(error)
                }
            } receiveValue: { [weak self] weather in
                self?.geoWeather.weather = weather
            }
            .store(in: &cancellables)
    }
    
    func weatherService(forWeather weather: Weather) -> WeatherService {
        return weatherServiceType.init(weather: weather)
    }
    
    private func isUpdateNeeded(for weather: Weather) -> Bool {
        return weatherService(forWeather: weather).isNeededWeatherUpdate()
    }
}
