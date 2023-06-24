//
//  WeatherListController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class WeatherListViewController: UIViewController {

    var viewModel: WeatherListViewModelDelegate! {
        didSet {
            // Implement handlers if exists
        }
    }

    var weatherListView = WeatherListView()

    override func loadView() {
        view = weatherListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

