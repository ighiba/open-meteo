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

        // Setup additional injections

        return view
    }
}