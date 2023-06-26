//
//  GeoWeatherDetailController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

class GeoWeatherDetailViewController: UIViewController {

    var viewModel: GeoWeatherDetailViewModelDelegate! {
        didSet {
            viewModel.geoWeatherDidChangedHandler = { [weak self] geoWeather in
                self?.configureViews(with: geoWeather)
            }
        }
    }

    var geoWeatherDetailView = GeoWeatherDetailView()

    override func loadView() {
        self.view = geoWeatherDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoWeatherDetailView.delegate = self
        
        self.view.backgroundColor = .cyan
        
        geoWeatherDetailView.configure(with: viewModel.geoWeather)
    }
    
    func configureViews(with geoWeather: GeoWeather) {
        geoWeatherDetailView.configure(with: geoWeather)
    }
}

extension GeoWeatherDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

