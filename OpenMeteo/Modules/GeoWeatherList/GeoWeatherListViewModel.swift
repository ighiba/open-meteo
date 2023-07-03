//
//  GeoWeatherListViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

protocol GeoWeatherListViewModelDelegate: AnyObject {
    var geoWeatherList: [GeoWeather] { get }
    var geoWeatherListDidChangedHandler: (([GeoWeather]) -> Void)? { get set }
    func addGeoWeather(_ geoWeather: GeoWeather)
}

class GeoWeatherListViewModel: GeoWeatherListViewModelDelegate {

    var geoWeatherList: [GeoWeather] = [] {
        didSet {
            geoWeatherListDidChangedHandler?(geoWeatherList)
        }
    }
    
    var geoWeatherListDidChangedHandler: (([GeoWeather]) -> Void)?
    
    init() {
        geoWeatherList = GeoWeather.sampleData
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        #if DEBUG
        let ids = geoWeatherList.map { $0.id }
        guard !ids.contains(geoWeather.id) else { return }
        geoWeatherList = geoWeatherList + [geoWeather]
        #endif
    }
    
}

