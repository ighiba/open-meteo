//
//  GeoWeatherDetailScreenAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

class GeoWeatherDetailScreenAssembly {
    class func configureScreen(with geoWeather: GeoWeather) -> UIViewController {
        let networkManager = NetworkManagerImpl()
        let weatherServiceType = WeatherServiceImpl.self
        
        let viewModel = GeoWeatherDetailViewModel(geoWeather: geoWeather, networkManager: networkManager, weatherServiceType: weatherServiceType)
        
        return GeoWeatherDetailViewController(viewModel: viewModel)
    }
    
    class func configureScreen(with geocoding: Geocoding) -> UIViewController {
        let geoWeather = GeoWeather(geocoding: geocoding)
        let networkManager = NetworkManagerImpl()
        let weatherServiceType = WeatherServiceImpl.self
        
        let viewModel = GeoWeatherDetailViewModel(geoWeather: geoWeather, networkManager: networkManager, weatherServiceType: weatherServiceType)
        
        return GeoWeatherDetailViewController(viewModel: viewModel)
    }
}
