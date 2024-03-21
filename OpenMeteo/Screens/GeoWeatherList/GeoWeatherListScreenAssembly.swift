//
//  GeoWeatherListScreenAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class GeoWeatherListScreenAssembly {
    class func configureScreen() -> UIViewController {
        let networkManager = NetworkManagerImpl()
        let dataManager = DataManagerImpl()
        let locationManager = LocationManager()
        let viewModel = GeoWeatherListViewModel(networkManager: networkManager, dataManager: dataManager, locationManager: locationManager)
        
        let view = GeoWeatherListViewController(viewModel: viewModel)

        return OpenMeteoNavigationController(rootViewController: view)
    }
}
