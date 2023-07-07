//
//  GeoWeatherListViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation
import Combine

private let currentLocationId: Int = -1

protocol GeoWeatherListViewModelDelegate: AnyObject {
    var geoWeatherList: [GeoWeather] { get }
    var geoWeatherListDidChangeHandler: (([GeoWeather]) -> Void)? { get set }
    var geoWeatherIdsDidChangeHandler: (([GeoWeather.ID]) -> Void)? { get set }
    func loadInitialData()
    func updateAllWeather()
    func addGeoWeather(_ geoWeather: GeoWeather)
    func deleteGeoWeather(withId id: GeoWeather.ID)
}

class GeoWeatherListViewModel: GeoWeatherListViewModelDelegate {
    
    // MARK: - Properties

    var geoWeatherList: [GeoWeather] = [] {
        didSet {
            geoWeatherListDidChangeHandler?(geoWeatherList)
        }
    }
    
    var geoWeatherListDidChangeHandler: (([GeoWeather]) -> Void)?
    var geoWeatherIdsDidChangeHandler: (([GeoWeather.ID]) -> Void)?
    
    var networkManager: NetworkManager!
    var dataManager: DataManager!
    var locationManager: LocationManager!
    
    private var weatherCancellables = Set<AnyCancellable>()

    // MARK: - Methods
    
    func loadInitialData() {
        #if DEBUG
        //configureAndSaveDataInStore(GeoWeather.sampleData)
        #endif
        
        locationManager.locationUpdateHandler = { [weak self] latitude, longitude in
            self?.addCurrentLocation(latitude: latitude, longitude: longitude)
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        geoWeatherList = obtainAndConfigureDataFromStore()
    }
    
    private func addCurrentLocation(latitude: Float, longitude: Float) {
        let currentLocationLocalized = NSLocalizedString("Your location", comment: "")
        let currentLocationGeocoding = Geocoding(
            id: currentLocationId,
            name: currentLocationLocalized,
            latitude: latitude,
            longitude: longitude,
            country: "",
            adminLocation: ""
        )
        
        let geoWeatherForUpdate: GeoWeather
        
        if let currentLocationGeoWeather = geoWeatherList.item(withId: currentLocationId) {
            currentLocationGeoWeather.geocoding = currentLocationGeocoding
            geoWeatherForUpdate = currentLocationGeoWeather
        } else {
            let newCurrentLocation = GeoWeather(geocoding: currentLocationGeocoding)
            geoWeatherForUpdate = newCurrentLocation
        }
        
        insertGeoWeather(geoWeatherForUpdate, at: 0)
    }
    
    func updateAllWeather() {
        return
        weatherCancellables.forEach { $0.cancel() }
        weatherCancellables.removeAll()
        updateGeoWeatherList(geoWeatherList)
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        let ids = geoWeatherList.map { $0.id }
        guard !ids.contains(geoWeather.id) else { return }
        geoWeatherList = geoWeatherList + [geoWeather]
        configureAndSaveDataInStore(geoWeatherList)
        updateGeoWeatherList([geoWeather])
    }
    
    func insertGeoWeather(_ geoWeather: GeoWeather, at index: Int) {
        if let existingIndex = geoWeatherList.index(for: geoWeather.id) {
            if existingIndex != index {
                geoWeatherList.move(fromOffsets: IndexSet(integer: existingIndex), toOffset: index)
            } else {
                geoWeatherList[index] = geoWeather
            }
        } else {
            geoWeatherList.insert(geoWeather, at: index)
        }
        configureAndSaveDataInStore(geoWeatherList)
        updateGeoWeatherList(geoWeatherList)
    }
    
    func deleteGeoWeather(withId id: GeoWeather.ID) {
        guard let index = geoWeatherList.index(for: id) else { return }
        let deletedGeoWeather = geoWeatherList.remove(at: index)
        dataManager.delete(geoModelWithId: deletedGeoWeather.geocoding.id)
    }
    
    private func configureAndSaveDataInStore(_ geoWeatherList: [GeoWeather]) {
        let geoModelList = geoWeatherList.map({ $0.geocoding }).map({ GeoModel(geocoding: $0)})
        dataManager.save(geoModelList)
    }
    
    private func obtainAndConfigureDataFromStore() -> [GeoWeather] {
        let geoModelList = dataManager.obtainGeoModelList()
        let geoWeatherList = geoModelList.map({ Geocoding(geoModel: $0) }).map({ GeoWeather(geocoding: $0) })
        return geoWeatherList
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
    
    private func updateWeatherForGeoWeatherList(geoWeatherList: [GeoWeather]) -> AnyPublisher<Void, FetchError> {
        let fetchWeatherPublishers = geoWeatherList.map { geoWeather in
            fetchWeatherPublisher(geocoding: geoWeather.geocoding)
                .map { [weak self] weather in
                    print("updated weather for \(geoWeather.geocoding.name)")
                    geoWeather.weather = weather
                    self?.geoWeatherIdsDidChangeHandler?([geoWeather.id])
                }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(fetchWeatherPublishers)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    private func fetchWeatherPublisher(geocoding: Geocoding) -> AnyPublisher<Weather, FetchError> {
        return Future<Weather, FetchError> { [weak self] promise in
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
