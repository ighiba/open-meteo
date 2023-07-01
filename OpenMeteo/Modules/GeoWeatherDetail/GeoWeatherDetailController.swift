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

    let closeButtonContainer = BlurredButtonContainer(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    let backgroundView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.1))
    var geoWeatherDetailScrollView = GeoWeatherDetailView()
    
    lazy var navigationBarOffset = self.view.convert(self.navigationController!.navigationBar.frame, to: self.view).origin.y
    
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
        geoWeatherDetailScrollView.delegate = self
        configureNavigationBar()
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        closeButtonContainer.button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButtonContainer.setBlurAlpha(0.0)

        let closeButtonBarItem = UIBarButtonItem(customView: closeButtonContainer)
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
        let preferredContainersStyle = ContainerStyle.obtainContainerStyle(for: skyType)
        geoWeatherDetailScrollView.preferredContainersStyle = preferredContainersStyle
        closeButtonContainer.updateBlurStyle(preferredContainersStyle.blurStyle)
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
        let offsetY = scrollView.contentOffset.y + navigationBarOffset
        if offsetY < 0 {
            closeButtonContainer.animateHideButtonBackground()
        } else {
            closeButtonContainer.animateShowButtonBackground()
        }
    }
}

