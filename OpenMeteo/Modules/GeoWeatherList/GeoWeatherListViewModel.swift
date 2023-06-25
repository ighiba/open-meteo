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
    
}

