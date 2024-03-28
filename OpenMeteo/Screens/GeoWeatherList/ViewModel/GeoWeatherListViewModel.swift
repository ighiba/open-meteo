//
//  GeoWeatherListViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation
import Combine

enum UpdateRule {
    case updateAll
    case reload(ids: [GeoWeather.ID])
}

protocol GeoWeatherListViewModelDelegate: AnyObject {
    var geoWeatherList: [GeoWeather] { get }
    var geoWeatherListUpdatePublisher: AnyPublisher<UpdateRule, Never> { get }
    func loadInitialData()
    func updateAllWeather()
    func updateGeoWeather(withId id: GeoWeather.ID, weather: Weather)
    func addGeoWeather(_ geoWeather: GeoWeather)
    func insertGeoWeather(_ geoWeather: GeoWeather, at index: Int)
    func deleteGeoWeather(withId id: GeoWeather.ID)
    func weatherService(forWeather weather: Weather) -> WeatherService
}

final class GeoWeatherListViewModel: GeoWeatherListViewModelDelegate {
    
    // MARK: - Properties
    
    var geoWeatherList: [GeoWeather] = [] {
        didSet {
            if geoWeatherList.count != oldValue.count {
                geoWeatherListUpdateSubject.send(.updateAll)
            }
        }
    }
    
    var geoWeatherListUpdatePublisher: AnyPublisher<UpdateRule, Never> { geoWeatherListUpdateSubject.eraseToAnyPublisher() }
    private let geoWeatherListUpdateSubject: PassthroughSubject<UpdateRule, Never> = PassthroughSubject()
    
    private let networkManager: NetworkManager
    private let dataManager: DataManager
    private let locationManager: LocationManager
    private let weatherServiceType: WeatherService.Type
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(networkManager: NetworkManager, dataManager: DataManager, locationManager: LocationManager, weatherServiceType: WeatherService.Type) {
        self.networkManager = networkManager
        self.dataManager = dataManager
        self.locationManager = locationManager
        self.weatherServiceType = weatherServiceType
    }

    // MARK: - Methods
    
    func loadInitialData() {
        #if DEBUG
        //saveGeoWeatherList(GeoWeather.sampleData)
        #endif
        
        locationManager.locationUpdateHandler = { [weak self] latitude, longitude in
            self?.addCurrentLocationGeoWeather(fromLatitude: latitude, longitude: longitude)
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        geoWeatherList = loadGeoWeatherList()
    }
    
    private func addCurrentLocationGeoWeather(fromLatitude latitude: Float, longitude: Float) {
        let currentLocationGeocoding = Geocoding.currentLocation(fromLatitude: latitude, longitude: longitude)
        
        let geoWeatherForUpdate: GeoWeather
        if let currentLocationGeoWeather = geoWeatherList.item(withId: currentLocationGeocoding.id) {
            geoWeatherForUpdate = GeoWeather(geocoding: currentLocationGeocoding, weather: currentLocationGeoWeather.weather)
        } else {
            geoWeatherForUpdate = GeoWeather(geocoding: currentLocationGeocoding)
        }
        
        insertGeoWeather(geoWeatherForUpdate, at: 0)
        updateWeather(forGeoWeather: geoWeatherForUpdate)
    }
    
    func updateAllWeather() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        updateWeather(forGeoWeatherList: geoWeatherList)
    }
    
    func updateGeoWeather(withId id: GeoWeather.ID, weather: Weather) {
        guard let index = geoWeatherList.index(withItemId: id) else { return }
        
        geoWeatherList[index].weather = weather
        geoWeatherListUpdateSubject.send(.reload(ids: [id]))
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        let ids = geoWeatherList.map { $0.id }
        guard !ids.contains(geoWeather.id) else { return }
        
        geoWeatherList.append(geoWeather)
        saveGeoWeatherList(geoWeatherList)
    }
    
    func insertGeoWeather(_ geoWeather: GeoWeather, at index: Int) {
        if let existingIndex = geoWeatherList.index(withItemId: geoWeather.id) {
            if existingIndex != index {
                geoWeatherList.move(fromOffsets: IndexSet(integer: existingIndex), toOffset: index)
            } else {
                geoWeatherList[index] = geoWeather
            }
        } else {
            geoWeatherList.insert(geoWeather, at: index)
        }
        
        saveGeoWeatherList(geoWeatherList)
    }
    
    func deleteGeoWeather(withId id: GeoWeather.ID) {
        guard let index = geoWeatherList.index(withItemId: id) else { return }
        
        let deletedGeoWeather = geoWeatherList.remove(at: index)
        dataManager.delete(geoModelWithId: deletedGeoWeather.geocoding.id)
    }
    
    func weatherService(forWeather weather: Weather) -> WeatherService {
        return weatherServiceType.init(weather: weather)
    }
    
    // MARK: - DB
    
    private func loadGeoWeatherList() -> [GeoWeather] {
        let geoModelList = dataManager.obtainGeoModelList()
        let geoWeatherList = geoModelList.map({ Geocoding(geoModel: $0) }).map({ GeoWeather(geocoding: $0) })
        
        return geoWeatherList
    }
    
    private func saveGeoWeatherList(_ geoWeatherList: [GeoWeather]) {
        let geoModelList = geoWeatherList.map({ $0.geocoding }).map({ GeoModel(geocoding: $0) })
        dataManager.save(geoModelList)
    }
    
    // MARK: - Network
    
    private func updateWeather(forGeoWeather geoWeather: GeoWeather) {
        updateWeather(forGeoWeatherList: [geoWeather])
    }
    
    private func updateWeather(forGeoWeatherList geoWeatherList: [GeoWeather]) {
        fetchWeatherPublishers(forGeoWeatherList: geoWeatherList)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Weather update error: \(error)")
                }
            }, receiveValue: { _ in
                
            })
            .store(in: &cancellables)
    }
    
    private func fetchWeatherPublishers(forGeoWeatherList geoWeatherList: [GeoWeather]) -> AnyPublisher<Void, FetchError> {
        let fetchWeatherPublishers = geoWeatherList.map { geoWeather in
            networkManager.fetchWeather(endpoint: .standart(geocoding: geoWeather.geocoding))
                .map { [weak self] weather in
                    self?.updateGeoWeather(withId: geoWeather.id, weather: weather)
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(fetchWeatherPublishers)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
}
