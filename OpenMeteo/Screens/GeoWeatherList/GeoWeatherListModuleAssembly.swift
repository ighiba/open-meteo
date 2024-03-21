//
//  GeoWeatherListModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class GeoWeatherListModuleAssembly {
    class func configureModule() -> UIViewController {
        let networkManager = NetworkManagerImpl()
        let dataManager = DataManagerImpl()
        let locationManager = LocationManager()
        let viewModel = GeoWeatherListViewModel(networkManager: networkManager, dataManager: dataManager, locationManager: locationManager)
        
        let view = GeoWeatherListViewController()
        view.viewModel = viewModel

        let navigationController = OpenMeteoNavigationController()
        navigationController.viewControllers = [view]

        return navigationController
    }
}
