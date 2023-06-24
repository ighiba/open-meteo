//
//  WeatherListModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class WeatherListModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = WeatherListViewController()
        let viewModel = WeatherListViewModel()

        view.viewModel = viewModel

        // Setup additional injections

        return view
    }
}