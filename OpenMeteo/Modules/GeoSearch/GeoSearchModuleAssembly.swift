//
//  GeoSearchModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit

class GeoSearchModuleAssembly {
    class func configureModule() -> UIViewController {
        let view = GeoSearchViewController()
        let viewModel = GeoSearchViewModel()

        view.viewModel = viewModel

        return view
    }
}
