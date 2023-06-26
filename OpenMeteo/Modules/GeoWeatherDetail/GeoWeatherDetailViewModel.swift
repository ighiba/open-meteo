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
    
}

