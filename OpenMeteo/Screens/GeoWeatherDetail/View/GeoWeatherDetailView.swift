//
//  GeoWeatherDetailView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

class GeoWeatherDetailView: UIScrollView {
    
    private let spacing: CGFloat = 25
    
    var preferredContainersStyle: ContainerStyle = .light {
        didSet {
            updateViewsStyle(with: preferredContainersStyle)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    override func updateConstraints() {
        super.updateConstraints()
    }

    private func setViews() {
        addSubview(contentContainer)

        contentContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
        
        todayMinMaxTemeperatureRangeContainer.snp.makeConstraints { make in
            make.width.equalTo(todayMinMaxTemeperatureRangeContainer.preferredWidth)
            make.height.equalTo(25)
        }

        hourlyForecastCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(HourForecastCell.height)
        }
        
        apparentTemperatureAndWindHorizontalStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(contentContainer.snp.width).multipliedBy(0.5).inset(spacing / 4)
        }
        
        apparentTemperatureContainer.snp.makeConstraints { make in
            make.width.equalTo(apparentTemperatureAndWindHorizontalStack.snp.height)
            make.height.equalToSuperview()
        }
        
        windContainer.snp.makeConstraints { make in
            make.width.equalTo(apparentTemperatureAndWindHorizontalStack.snp.height)
            make.height.equalToSuperview()
        }
        
        relativeHumidityAndPrecipitationStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(contentContainer.snp.width).multipliedBy(0.5).inset(spacing / 4)
        }
        
        relativeHumidityContainer.snp.makeConstraints { make in
            make.width.equalTo(relativeHumidityAndPrecipitationStack.snp.height)
            make.height.equalToSuperview()
        }
        
        precipitationSumContainer.snp.makeConstraints { make in
            make.width.equalTo(relativeHumidityAndPrecipitationStack.snp.height)
            make.height.equalToSuperview()
        }

        contentLayoutGuide.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(contentContainer.snp.bottom).offset(spacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(geocoding: Geocoding, weather: Weather?) {
        configureGeocodingViews(geocoding)
        
        if let weather = weather {
            configureWeatherViews(weather)
        }
    }
    
    private func configureGeocodingViews(_ geocoding: Geocoding) {
        let locationName = geocoding.name
        geoNameLabel.setAttributedTextWithShadow(locationName)
    }
    
    private func configureWeatherViews(_ weather: Weather) {
        let currentHourForecast = weather.obtainForecastForCurrentHour()
        let currentDayForecast = weather.obtainCurrentDayForecast()
        
        let currentHourTemperature = currentHourForecast.temperature
        let currentDayTemperatureRange = currentDayForecast?.temperatureRange
        let weatherCodeDescription = weather.currentWeatherCode.localizedDescription
        let hourlyForecastFor24Hours = weather.obtainHourlyForecastFor(nextHours: 24)
        let dailyForecastForWeek =  weather.obtainDailyForecastFor(nextDays: 7)
        let wind = currentHourForecast.wind
        let relativeHumidity = currentHourForecast.relativeHumidity
        let precipitationSum = currentDayForecast?.precipitationSum ?? 0
        let tomorrowPrecipitationSum = weather.obtainDailyForecastFor(nextDays: 1).last?.precipitationSum
        
        currentTemperatureLabel.setTemperature(currentHourTemperature.real)
        todayMinMaxTemeperatureRangeContainer.setTemperature(range: currentDayTemperatureRange)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(weatherCodeDescription)
        hourlyForecastCollectionView.setup(with: hourlyForecastFor24Hours)
        dailyForecastContainer.setup(with: dailyForecastForWeek)
        apparentTemperatureContainer.setup(withHourTemperature: currentHourTemperature)
        windContainer.configure(with: wind)
        relativeHumidityContainer.configure(relativeHumidity: relativeHumidity)
        precipitationSumContainer.configure(with: precipitationSum, tomorrowPrecipitation: tomorrowPrecipitationSum)
    }
    
    func updateViewsStyle(with style: ContainerStyle) {
        hourlyForecastCollectionView.updateContainerStyle(with: style)
        dailyForecastContainer.updateContainerStyle(with: style)
        apparentTemperatureContainer.updateContainerStyle(with: style)
        windContainer.updateContainerStyle(with: style)
        relativeHumidityContainer.updateContainerStyle(with: style)
        precipitationSumContainer.updateContainerStyle(with: style)
    }
    
    // MARK: - Views
    
    lazy var contentContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [
            mainInfoContainer,
            hourlyForecastCollectionView,
            dailyForecastContainer,
            apparentTemperatureAndWindHorizontalStack,
            relativeHumidityAndPrecipitationStack
        ])
        
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.spacing = spacing
        
        return container
    }()

    lazy var mainInfoContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [
            geoNameLabel,
            currentTemperatureLabel,
            todayMinMaxTemeperatureRangeContainer,
            weatherCodeDescriptionLabel
        ])
        
        container.axis = .vertical
        container.alignment = .center
        container.setCustomSpacing(10, after: todayMinMaxTemeperatureRangeContainer)
        
        return container
    }()
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()

        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = .white

        return label
    }()
    
    private let todayMinMaxTemeperatureRangeContainer: TemperatureRangeContainer = {
        let container = TemperatureRangeContainer()
        
        container.setColors(.white)
        
        return container
    }()
    
    private let weatherCodeDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let hourlyForecastCollectionView: HourlyForecastCollectionView = {
        return HourlyForecastCollectionView()
    }()
    
    private let dailyForecastContainer: DailyForecastContainer = {
        return DailyForecastContainer()
    }()
    
    lazy var apparentTemperatureAndWindHorizontalStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [apparentTemperatureContainer, windContainer])
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    lazy var apparentTemperatureContainer: ApparentTemperatureContainer = {
        return ApparentTemperatureContainer()
    }()
    
    lazy var windContainer: WindContainer = {
        return WindContainer()
    }()
    
    lazy var relativeHumidityAndPrecipitationStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [relativeHumidityContainer, precipitationSumContainer])
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack
    }()
    
    lazy var relativeHumidityContainer: RelativeHumidityContainer = {
        return RelativeHumidityContainer()
    }()
    
    lazy var precipitationSumContainer: PrecipitationSumContainer = {
        return PrecipitationSumContainer()
    }()
}
