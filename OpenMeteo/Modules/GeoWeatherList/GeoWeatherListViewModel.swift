//
//  GeoWeatherListViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation
import Combine

protocol GeoWeatherListViewModelDelegate: AnyObject {
    var geoWeatherList: [GeoWeather] { get }
    var geoWeatherListDidChangedHandler: (([GeoWeather]) -> Void)? { get set }
    var geoWeatherIdsDidChangedHandler: (([GeoWeather.ID]) -> Void)? { get set }
    func updateAllWeather()
    func addGeoWeather(_ geoWeather: GeoWeather)
}

class GeoWeatherListViewModel: GeoWeatherListViewModelDelegate {
    
    // MARK: - Properties

    var geoWeatherList: [GeoWeather] = [] {
        didSet {
            geoWeatherListDidChangedHandler?(geoWeatherList)
        }
    }
    
    var geoWeatherListDidChangedHandler: (([GeoWeather]) -> Void)?
    var geoWeatherIdsDidChangedHandler: (([GeoWeather.ID]) -> Void)?
    
    var networkManager: NetworkManager!
    
    private var weatherCancellables = Set<AnyCancellable>()
    
    init() {
        geoWeatherList = GeoWeather.sampleData
    }

    // MARK: - Methods
    
    func updateAllWeather() {
        weatherCancellables.forEach { $0.cancel() }
        weatherCancellables.removeAll()
       
        updateGeoWeatherList(geoWeatherList)
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        let ids = geoWeatherList.map { $0.id }
        guard !ids.contains(geoWeather.id) else { return }
        
        geoWeatherList = geoWeatherList + [geoWeather]
        updateGeoWeatherList([geoWeather])
    }
    
    private func updateGeoWeatherList(_ geoWeatherList: [GeoWeather]) {
        updateWeatherForGeoWeatherList(geoWeatherList: geoWeatherList)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Weather update error:", error)
                }
            } receiveValue: { _ in
                
            }
            .store(in: &weatherCancellables)
    }
    
    private func updateWeatherForGeoWeatherList(geoWeatherList: [GeoWeather]) -> AnyPublisher<Void, FetchErorr> {
        let fetchWeatherPublishers = geoWeatherList.map { geoWeather in
            fetchWeatherPublisher(geocoding: geoWeather.geocoding)
                .map { [weak self] weather in
                    print("updated weather for \(geoWeather.geocoding.name)")
                    geoWeather.weather = weather
                    self?.geoWeatherIdsDidChangedHandler?([geoWeather.id])
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(fetchWeatherPublishers)
            .map { _ in () }
            .eraseToAnyPublisher()
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

