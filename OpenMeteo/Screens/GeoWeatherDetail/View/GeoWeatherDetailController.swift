//
//  GeoWeatherDetailViewController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit
import Combine

final class GeoWeatherDetailViewController: UIViewController {
    
    enum NavigationBarConfiguration: Equatable {
        case standart
        case addNew(isAllowedToAdd: Bool)
    }
    
    // MARK: - Properties

    let viewModel: GeoWeatherDetailViewModelDelegate
    
    var geoWeatherDidAdd: ((GeoWeather) -> Void)?
    var updateHandler: ((GeoWeather) -> Void)?
    
    var navigationBarConfiguration: NavigationBarConfiguration = .standart
    
    lazy var navigationBarOffset: CGFloat = calculateNavigationBarOffset()
    
    private let refreshControl = UIRefreshControl()

    private let backgroundView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.1))
    private let geoWeatherDetailScrollView = GeoWeatherDetailView()
    
    private var closeButtonContainer: BlurredButtonContainer?
    private var addButtonContainer: BlurredButtonContainer?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { statusBarStyle }
    
    var statusBarStyle: UIStatusBarStyle = .darkContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: GeoWeatherDetailViewModelDelegate) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle

    override func loadView() {
        view = configureView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geoWeatherDetailScrollView.delegate = self

        setupRefreshControl()
        setupNavigationBar()
        setupBindings()
        
        let needForceUpdate = navigationBarConfiguration != .standart
        viewModel.updateWeather(forcedUpdate: needForceUpdate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.statusBarStyle = .lightContent
        }
    }
    
    // MARK: - Methods
    
    private func calculateNavigationBarOffset() -> CGFloat {
        let navigationBarRect = navigationController?.navigationBar.frame ?? .zero
        return view.convert(navigationBarRect, to: view).origin.y
    }
    
    private func configureView() -> UIView {
        backgroundView.addSubview(geoWeatherDetailScrollView)
        makeConstraintsForMainView(geoWeatherDetailScrollView)
        
        return backgroundView
    }
    
    private func makeConstraintsForMainView(_ view: UIView) {
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupRefreshControl() {
        guard navigationBarConfiguration == .standart else { return }
        
        geoWeatherDetailScrollView.refreshControl = refreshControl
        refreshControl.tintColor = .white
    }
    
    private func setupNavigationBar() {
        setupNavigationBarButtons()
        setupNavigationBarAppearance()
    }
    
    private func setupNavigationBarButtons() {
        var leftBarButtonItem: UIBarButtonItem? = nil
        var rightBarButtonItem: UIBarButtonItem? = nil
        
        closeButtonContainer = configureButtonContainer(withSystemImageName: "xmark", action: #selector(closeButtonTapped))
        rightBarButtonItem = UIBarButtonItem(customView: closeButtonContainer!)
        
        if case .addNew(let isAllowedToAdd) = navigationBarConfiguration, isAllowedToAdd {
            addButtonContainer = configureButtonContainer(withSystemImageName: "plus", action: #selector(addButtonTapped))
            leftBarButtonItem = UIBarButtonItem(customView: addButtonContainer!)
        }
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.hidesBackButton = true
    }
    
    private func setupNavigationBarAppearance() {
        navigationItem.largeTitleDisplayMode = .never
    
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance.configureTransparentBackgroundAppearance()
        navBarAppearance.backgroundColor = .white.withAlphaComponent(0)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = nil
    }
    
    private func setupBindings() {
        viewModel.geoWeatherPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] geoWeather in
                self?.handleRefreshControlEnd()
                self?.updateHandler?(geoWeather)
                self?.update(withGeoWeather: geoWeather)
            }
            .store(in: &cancellables)

        viewModel.networkErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleRefreshControlEnd()
                guard self?.viewModel.geoWeather.weather == nil else { return }
                self?.showNetworkErrorView()
            }
            .store(in: &cancellables)
    }

    private func update(withGeoWeather geoWeather: GeoWeather) {
        let locationName = geoWeather.geocoding.name
        let weatherService = viewModel.weatherService(forWeather: geoWeather.weather)
        let currentHourForecast = weatherService.currentHourForecast
        let currentDayForecast = weatherService.currentDayForecast
        let nextDayForecast = weatherService.obtainDailyForecast(forNextDays: 1).last
        let hourlyForecastFor24Hours = weatherService.obtainHourlyForecast(forNextHours: 24)
        let dailyForecastForWeek = weatherService.obtainDailyForecast(forNextDays: 7)
        
        geoWeatherDetailScrollView.update(
            withLocationName: locationName,
            currentHourForecast: currentHourForecast,
            currentDayForecast: currentDayForecast,
            nextDayForecast: nextDayForecast,
            hourlyForecastFor24Hours: hourlyForecastFor24Hours,
            dailyForecastForWeek: dailyForecastForWeek
        )
        
        let skyType = weatherService.currentSkyType
        updateViewsStyle(forSkyType: skyType)
    }
    
    private func updateViewsStyle(forSkyType skyType: SkyType) {
        let containerStyle = ContainerStyle.obtainContainerStyle(for: skyType)
        
        updateBackgroundView(for: skyType)
        updateContainerStyle(with: containerStyle)
        updateButtonsBlurStyle(with: containerStyle)
    }
    
    private func updateBackgroundView(for skyType: SkyType) {
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundView.setColors(weatherColorSet: colorSet)
    }
    
    private func updateContainerStyle(with containerStyle: ContainerStyle) {
        geoWeatherDetailScrollView.preferredContainersStyle = containerStyle
    }
    
    private func updateButtonsBlurStyle(with containerStyle: ContainerStyle) {
        let blurStyle = containerStyle.blurStyle
        closeButtonContainer?.updateBlurStyle(blurStyle)
        addButtonContainer?.updateBlurStyle(blurStyle)
    }
    
    private func configureButtonContainer(withSystemImageName systemImageName: String, action: Selector) -> BlurredButtonContainer {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: systemImageName)
        
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        let buttonContainer = BlurredButtonContainer(button: button)
        buttonContainer.setBlurAlpha(0)
        
        return buttonContainer
    }
    
    private func showNetworkErrorView() {
        let transitionDuration: TimeInterval = 0.3
        
        let errorView = GeoWeatherDetailNetworkErrorView()
        view.addSubview(errorView)
        makeConstraintsForMainView(errorView)
        
        geoWeatherDetailScrollView.alpha = 1.0
        UIView.animate(withDuration: transitionDuration * 0.3, animations: { [weak self] in
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
        case .standart:
            navigationController?.popViewController(animated: true)
        case .addNew(_):
            dismiss(animated: true)
        }
    }
    
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        geoWeatherDidAdd?(viewModel.geoWeather)
        dismiss(animated: true)
    }
}

// MARK: - Delegate

extension GeoWeatherDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + navigationBarOffset
        let shouldHideButtonsBackground = offsetY < 0
        
        if shouldHideButtonsBackground {
            closeButtonContainer?.transitionToHiddenBackground()
            addButtonContainer?.transitionToHiddenBackground()
        } else {
            closeButtonContainer?.transitionToRevealedBackground()
            addButtonContainer?.transitionToRevealedBackground()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            handleRefreshControlBegin()
        }
    }
}
