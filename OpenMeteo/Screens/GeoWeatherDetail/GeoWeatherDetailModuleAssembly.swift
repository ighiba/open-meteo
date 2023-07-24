//
//  GeoWeatherDetailModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

class GeoWeatherDetailModuleAssembly {
    class func configureModule(with geoWeather: GeoWeather) -> UIViewController {
        let view = GeoWeatherDetailViewController()
        let viewModel = GeoWeatherDetailViewModel()

        viewModel.geoWeather = geoWeather
        viewModel.networkManager = NetworkManagerImpl()
        view.viewModel = viewModel

        return view
    }
    
    class func configureModule(with geocoding: Geocoding) -> UIViewController {
        let view = GeoWeatherDetailViewController()
        let viewModel = GeoWeatherDetailViewModel()

        viewModel.geoWeather = GeoWeather(geocoding: geocoding)
        viewModel.networkManager = NetworkManagerImpl()
        view.viewModel = viewModel

        return view
    }
}
