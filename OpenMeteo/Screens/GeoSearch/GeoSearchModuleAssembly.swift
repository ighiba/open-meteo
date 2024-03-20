//
//  GeoSearchModuleAssembly.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit

class GeoSearchModuleAssembly {
    class func configureModule() -> UIViewController {
        let networkManager = NetworkManagerImpl()
        let viewModel = GeoSearchViewModel(networkManager: networkManager)
        
        return GeoSearchViewController(viewModel: viewModel)
    }
}
