//
//  GeoWeatherDetailController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

class GeoWeatherDetailViewController: UIViewController {
    
    enum NavigationBarConfiguration {
        case detail
        case add
    }
    
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
    
    var navigationBarConfiguration: NavigationBarConfiguration = .detail
    
    var didAddedCallback: ((GeoWeather) -> Void)?
    
    lazy var navigationBarOffset: CGFloat = {
        let navigationBarRect = self.navigationController?.navigationBar.frame ?? .zero
        return self.view.convert(navigationBarRect, to: self.view).origin.y
    }()
    
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
        updateNavigationBarAppearance()
        
        if viewModel.geoWeather != nil {
            configureViews(with: viewModel.geoWeather)
        } else {
            configureViewsWithPlaceholder()
        }
    }
        
    func configureNavigationBar() {
        var leftBarButtonItem: UIBarButtonItem? = nil
        var rightBarButtonItem: UIBarButtonItem? = nil
        
        switch navigationBarConfiguration {
            
        case .detail:
            rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
            closeButtonContainer.button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            closeButtonContainer.setBlurAlpha(0.0)
        case .add:
            leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeAddButtonTapped))
            rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
            break
        }
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.hidesBackButton = true
    }
    
    func updateNavigationBarAppearance() {
        self.navigationItem.largeTitleDisplayMode = .never
    
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .white.withAlphaComponent(0.0)
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = nil
    }

    func configureViewsWithPlaceholder() {
        updateViews(for: .day)
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

    @objc func closeAddButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        didAddedCallback?(viewModel.geoWeather)
        self.dismiss(animated: true)
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

