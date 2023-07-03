//
//  GeoWeatherDetailViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import Foundation

protocol GeoWeatherDetailViewModelDelegate: AnyObject {
    var geoWeather: GeoWeather! { get }
    var geoWeatherDidChangedHandler: ((GeoWeather) -> Void)? { get set }
}

class GeoWeatherDetailViewModel: GeoWeatherDetailViewModelDelegate {
    
    var geoWeather: GeoWeather! {
        didSet {
            geoWeatherDidChangedHandler?(geoWeather)
        }
    }
    
    var geoWeatherDidChangedHandler: ((GeoWeather) -> Void)?
    
    func updateGeoWeather(with geocoding: Geocoding) {
        #if DEBUG
        DispatchQueue.global().async {
            sleep(1)
            DispatchQueue.main.sync {
                var geoWeather = GeoWeather.sampleData[0]
                geoWeather.id = Int.random(in: 32543...Int.max)
                self.geoWeather = geoWeather
            }
        }
        #endif
    }
}

