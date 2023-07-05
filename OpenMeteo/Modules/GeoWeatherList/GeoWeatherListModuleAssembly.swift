//
//  GeoWeatherListModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class GeoWeatherListModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = GeoWeatherListViewController()
        let viewModel = GeoWeatherListViewModel()

        view.viewModel = viewModel
        viewModel.networkManager = NetworkManagerImpl()
        viewModel.dataManager = DataManagerImpl()

        let navigationController = OpenMeteoNavigationController()
        navigationController.viewControllers = [view]

        return navigationController
    }
}
