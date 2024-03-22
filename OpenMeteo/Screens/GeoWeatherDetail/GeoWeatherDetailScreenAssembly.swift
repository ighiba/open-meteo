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
        let weatherService = WeatherServiceImpl(weather: geoWeather.weather)
        
        let viewModel = GeoWeatherDetailViewModel(geoWeather: geoWeather, networkManager: networkManager, weatherService: weatherService)
        
        return GeoWeatherDetailViewController(viewModel: viewModel)
    }
    
    class func configureScreen(with geocoding: Geocoding) -> UIViewController {
        let geoWeather = GeoWeather(geocoding: geocoding)
        let networkManager = NetworkManagerImpl()
        let weatherService = WeatherServiceImpl(weather: geoWeather.weather)
        
        let viewModel = GeoWeatherDetailViewModel(geoWeather: geoWeather, networkManager: networkManager, weatherService: weatherService)
        
        return GeoWeatherDetailViewController(viewModel: viewModel)
    }
}
