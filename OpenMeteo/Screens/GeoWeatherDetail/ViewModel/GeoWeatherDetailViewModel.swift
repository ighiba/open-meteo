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
}

final class GeoWeatherDetailViewModel: GeoWeatherDetailViewModelDelegate {
    
    // MARK: - Properties
    
    @Published var geoWeather: GeoWeather
    var geoWeatherPublisher: Published<GeoWeather>.Publisher { $geoWeather }
    var networkErrorPublisher: PassthroughSubject<FetchError, Never> = PassthroughSubject()
    
    var networkManager: NetworkManager!
    
    private var cancellables = Set<AnyCancellable>()
    
    init(geoWeather: GeoWeather) {
        self.geoWeather = geoWeather
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
                guard let geoWeather = self?.geoWeather else { return }
                self?.geoWeather = geoWeather
            }
            .store(in: &cancellables)
    }
    
    private func isUpdateNeeded(for weather: Weather?) -> Bool {
        return weather?.isUpdateNeeded() ?? true
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
