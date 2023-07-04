//
//  GeoWeatherDetailController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

class GeoWeatherDetailViewController: UIViewController {
    
    enum NavigationBarConfiguration: Equatable {
        case detail
        case add(isAlreadyAdded: Bool)
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
    var updateHandler: (() -> Void)?
    
    lazy var navigationBarOffset: CGFloat = {
        let navigationBarRect = self.navigationController?.navigationBar.frame ?? .zero
        return self.view.convert(navigationBarRect, to: self.view).origin.y
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    var statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
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
        updateNavigationBarAppearance()
        
        geoWeatherDetailScrollView.delegate = self
        
        let needForceUpdate = navigationBarConfiguration != .detail
        viewModel.updateWeather(forcedUpdate: needForceUpdate)
        
        configureViews(with: viewModel.geoWeather)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.statusBarStyle = .lightContent
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateHandler?()
    }
        
    func configureNavigationBar() {
        var leftBarButtonItem: UIBarButtonItem? = nil
        var rightBarButtonItem: UIBarButtonItem? = nil
        
        switch navigationBarConfiguration {
            
        case .detail:
            rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer)
            closeButtonContainer.button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            closeButtonContainer.setBlurAlpha(0.0)
        case .add(let isAlreadyAdded):
            leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeAddButtonTapped))
            guard !isAlreadyAdded else { break }
            rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
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

    func configureViews(with geoWeather: GeoWeather) {
        geoWeatherDetailScrollView.configure(geocoding: geoWeather.geocoding, weather: geoWeather.weather)
        
        if let weather = geoWeather.weather {
            let skyType = weather.obtainSkyType()
            updateViews(for: skyType)
        } else {
            updateViews(for: .day)
        }
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

