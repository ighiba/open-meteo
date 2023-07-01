//
//  GeoWeatherDetailController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

class GeoWeatherDetailViewController: UIViewController {
    
    // MARK: - Properties

    var viewModel: GeoWeatherDetailViewModelDelegate! {
        didSet {
            viewModel.geoWeatherDidChangedHandler = { [weak self] geoWeather in
                self?.configureViews(with: geoWeather)
            }
        }
    }

    let backgroundView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.1))
    var geoWeatherDetailScrollView = GeoWeatherDetailView()
    
    // MARK: - Layout

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

        configureNavigationBar()
        geoWeatherDetailScrollView.delegate = self
        configureViews(with: viewModel.geoWeather)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateChangeNavBarStyle(withDuration: 0.3, to: .black)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateChangeNavBarStyle(withDuration: 0.3, to: .default)
    }
    
    private func animateChangeNavBarStyle(withDuration duration: TimeInterval, to style: UIBarStyle) {
        UIView.animate(withDuration: duration) {
            self.navigationController?.navigationBar.barStyle = style
        }
    }
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let closeButtonBarItem = UIBarButtonItem(customView: closeButton)
        self.navigationItem.rightBarButtonItem = closeButtonBarItem
        self.navigationItem.hidesBackButton = true
    }
    
    func configureViews(with geoWeather: GeoWeather) {
        geoWeatherDetailScrollView.configure(with: geoWeather)

        let skyType = geoWeather.weather.obtainSkyType()
        updateViews(for: skyType)
    }
    
    func updateViews(for skyType: SkyType) {
        updateBackgroundView(for: skyType)
        geoWeatherDetailScrollView.preferredContainersStyle = ContainerStyle.obtainContainerStyle(for: skyType)
    }
    
    func updateBackgroundView(for skyType: SkyType) {
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundView.setColors(weatherColorSet: colorSet)
    }
}

// MARK: - Actions

extension GeoWeatherDetailViewController {
    @objc func closeButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Delegate

extension GeoWeatherDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

