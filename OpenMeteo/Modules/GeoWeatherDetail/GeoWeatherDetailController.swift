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
            viewModel.geoWeatherDidChangeHandler = { [weak self] geoWeather in
                self?.handleRefreshControlEnd()
                self?.configureViews(with: geoWeather)
            }
            viewModel.networkErrorHasOccurredHandler = { [weak self] in
                self?.handleRefreshControlEnd()
                guard self?.viewModel.geoWeather.weather == nil else { return }
                self?.showNetworkErrorView()
            }
        }
    }
    
    lazy var refreshControl = UIRefreshControl()

    private let backgroundView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.1))
    private var geoWeatherDetailScrollView = GeoWeatherDetailView()
    
    private var closeButtonContainer: BlurredButtonContainer?
    private var addButtonContainer: BlurredButtonContainer?
    
    var navigationBarConfiguration: NavigationBarConfiguration = .detail
    
    var geoWeatherDidAdd: ((GeoWeather) -> Void)?
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
        makeConstraintsForMainView(geoWeatherDetailScrollView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureRefreshControl()
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
    
    private func makeConstraintsForMainView(_ view: UIView) {
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureRefreshControl() {
        guard navigationBarConfiguration == .detail else { return }
        geoWeatherDetailScrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
    }
        
    private func configureNavigationBar() {
        var leftBarButtonItem: UIBarButtonItem? = nil
        var rightBarButtonItem: UIBarButtonItem? = nil
        
        closeButtonContainer = configureButtonContainer(withSystemName: "xmark", action: #selector(closeButtonTapped))
        
        switch navigationBarConfiguration {
        case .detail:
            closeButtonContainer?.setBlurAlpha(0.0)
            rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer!)
        case .add(let isAlreadyAdded):
            leftBarButtonItem = UIBarButtonItem(customView: closeButtonContainer!)
            guard !isAlreadyAdded else { break }
            addButtonContainer = configureButtonContainer(withSystemName: "plus", action: #selector(addButtonTapped))
            rightBarButtonItem = UIBarButtonItem(customView: addButtonContainer!)
        }
        
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.hidesBackButton = true
    }
    
    private func updateNavigationBarAppearance() {
        self.navigationItem.largeTitleDisplayMode = .never
    
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance.configureTransparentBackgroundAppearance()
        navBarAppearance.backgroundColor = .white.withAlphaComponent(0.0)
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = nil
    }

    private func configureViews(with geoWeather: GeoWeather) {
        geoWeatherDetailScrollView.configure(geocoding: geoWeather.geocoding, weather: geoWeather.weather)
        
        if let weather = geoWeather.weather {
            let skyType = weather.obtainSkyType()
            updateViews(for: skyType)
        } else {
            updateViews(for: .day)
        }
    }
    
    private func updateViews(for skyType: SkyType) {
        updateBackgroundView(for: skyType)
        let preferredContainersStyle = ContainerStyle.obtainContainerStyle(for: skyType)
        geoWeatherDetailScrollView.preferredContainersStyle = preferredContainersStyle
        closeButtonContainer?.updateBlurStyle(preferredContainersStyle.blurStyle)
        addButtonContainer?.updateBlurStyle(preferredContainersStyle.blurStyle)
    }
    
    private func updateBackgroundView(for skyType: SkyType) {
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundView.setColors(weatherColorSet: colorSet)
    }
    
    private func configureButtonContainer(withSystemName systemName: String, action: Selector) -> BlurredButtonContainer {
        let button = UIButton(type: .system)
        
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(UIImage(systemName:systemName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        return BlurredButtonContainer(button: button)
    }
    
    private func showNetworkErrorView() {
        let transitionDuration = 0.3
        
        let errorView = GeoWeatherDetailNetworkErrorView.configureDefault()
        self.view.addSubview(errorView)
        makeConstraintsForMainView(errorView)
        
        geoWeatherDetailScrollView.alpha = 1.0
        UIView.animate(withDuration: transitionDuration / 3, delay: 0, animations: { [weak self] in
            self?.geoWeatherDetailScrollView.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.geoWeatherDetailScrollView.removeFromSuperview()
            self?.geoWeatherDetailScrollView.alpha = 1.0
        })
        
        errorView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration) {
            errorView.alpha = 1.0
        }
    }
    
    private func handleRefreshControlBegin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel.updateWeather(forcedUpdate: true)
        }
    }
    
    private func handleRefreshControlEnd() {
        guard refreshControl.isRefreshing else { return }
        refreshControl.endRefreshing()
    }
}

// MARK: - Actions

extension GeoWeatherDetailViewController {
    @objc func closeButtonTapped(_ sender: UIButton) {
        switch navigationBarConfiguration {
        case .detail:
            self.navigationController?.popViewController(animated: true)
        case .add(_):
            self.dismiss(animated: true)
        }
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        geoWeatherDidAdd?(viewModel.geoWeather)
        self.dismiss(animated: true)
    }
}

// MARK: - Delegate

extension GeoWeatherDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + navigationBarOffset
        if offsetY < 0 {
            closeButtonContainer?.animateHideButtonBackground()
            addButtonContainer?.animateHideButtonBackground()
        } else {
            closeButtonContainer?.animateShowButtonBackground()
            addButtonContainer?.animateShowButtonBackground()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            handleRefreshControlBegin()
        }
    }
}
