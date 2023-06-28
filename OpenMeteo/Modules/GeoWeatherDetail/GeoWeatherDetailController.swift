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

    let backgroundView = GradientView()
    var geoWeatherDetailScrollView = GeoWeatherDetailView()

    override func loadView() {
        self.view = backgroundView
        self.view.addSubview(geoWeatherDetailScrollView)
        
        geoWeatherDetailScrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        geoWeatherDetailScrollView.delegate = self
        configureViews(with: viewModel.geoWeather)
    }
    
    func configureViews(with geoWeather: GeoWeather) {
        geoWeatherDetailScrollView.configure(with: geoWeather)
        updateBackgroundView(with: geoWeather)
    }
    
    func updateBackgroundView(with geoWeather: GeoWeather) {
        let skyType = obtainSkyType(with: geoWeather)
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundView.setColors(weatherColorSet: colorSet)
    }
    
    func obtainSkyType(with geoWeather: GeoWeather) -> SkyType {
        let weatherType = geoWeather.weather.obtainWeatherTypeForCurrentHour()

        switch weatherType {
        case .clearSky:
            if geoWeather.weather.isSunriseNow() {
                return .sunrise
            } else if geoWeather.weather.isSunsetNow() {
                return .sunset
            } else if geoWeather.weather.isNightNow() {
                return .night
            } else {
                return .day
            }
        case .fog, .cloudly:
            return .cloudy
        case .rain, .snow, .thunderstorm:
            return .rain
        }
    }
}

extension GeoWeatherDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

