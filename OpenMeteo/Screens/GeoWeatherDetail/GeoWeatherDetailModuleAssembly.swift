//
//  GeoWeatherDetailModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

class GeoWeatherDetailModuleAssembly {
    class func configureModule(with geoWeather: GeoWeather) -> UIViewController {
        let networkManager = NetworkManagerImpl()
        
        let viewModel = GeoWeatherDetailViewModel(geoWeather: geoWeather, networkManager: networkManager)
        
        let view = GeoWeatherDetailViewController()
        view.viewModel = viewModel

        return view
    }
    
    class func configureModule(with geocoding: Geocoding) -> UIViewController {
        let geoWeather = GeoWeather(geocoding: geocoding)
        let networkManager = NetworkManagerImpl()
        
        let viewModel = GeoWeatherDetailViewModel(geoWeather: geoWeather, networkManager: networkManager)

        let view = GeoWeatherDetailViewController()
        view.viewModel = viewModel

        return view
    }
}
