//
//  GeoWeatherDetailView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

final class GeoWeatherDetailView: UIScrollView {
    
    // MARK: - Properties
    
    private let contentSpacing: CGFloat = 25
    private var containerCoupleInset: CGFloat { contentSpacing / 4 }
    private let containerCoupleHeightMultiplier: CGFloat = 0.5
    private let contentContainerWidthMultiplier: CGFloat = 0.9
    private let todayTemperatureRangeContainerHeight: CGFloat = 25
    
    lazy var contentContainer = configureContentContainer()
    
    lazy var mainInfoContainer = configureMainInfoContainer()
    lazy var geoNameLabel = configureGeoNameLabel()
    lazy var currentTemperatureLabel = configureCurrentTemperatureLabel()
    lazy var todayTemeperatureRangeContainer = configureTodayTemperatureRangeContainer()
    lazy var weatherCodeDescriptionLabel = configureWeatherCodeDescriptionLabel()
    
    private let hourlyForecastContainer = HourlyForecastContainer()
    private let dailyForecastContainer = DailyForecastContainer()
    
    lazy var apparentTemperatureAndWindHorizontalStack = configureHorizontalContainerCouple(apparentTemperatureContainer, windContainer)
    private let apparentTemperatureContainer = ApparentTemperatureContainer()
    private let windContainer = WindContainer()
    
    lazy var relativeHumidityAndPrecipitationStack = configureHorizontalContainerCouple(relativeHumidityContainer, precipitationSumContainer)
    private let relativeHumidityContainer = RelativeHumidityContainer()
    private let precipitationSumContainer = PrecipitationSumContainer()
    
    var preferredContainersStyle: ContainerStyle = .light {
        didSet {
            updateViewsStyle(with: preferredContainersStyle)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        addSubview(contentContainer)
        
        contentLayoutGuide.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(contentContainer.snp.bottom).offset(contentSpacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(contentContainerWidthMultiplier)
        }
        
        todayTemeperatureRangeContainer.snp.makeConstraints { make in
            make.width.equalTo(todayTemeperatureRangeContainer.preferredWidth)
            make.height.equalTo(todayTemperatureRangeContainerHeight)
        }

        hourlyForecastContainer.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(HourForecastCell.height)
        }
        
        apparentTemperatureAndWindHorizontalStack.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(contentContainer.snp.width).multipliedBy(containerCoupleHeightMultiplier).inset(containerCoupleInset)
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
            make.height.equalTo(contentContainer.snp.width).multipliedBy(containerCoupleHeightMultiplier).inset(containerCoupleInset)
        }
        
        relativeHumidityContainer.snp.makeConstraints { make in
            make.width.equalTo(relativeHumidityAndPrecipitationStack.snp.height)
            make.height.equalToSuperview()
        }
        
        precipitationSumContainer.snp.makeConstraints { make in
            make.width.equalTo(relativeHumidityAndPrecipitationStack.snp.height)
            make.height.equalToSuperview()
        }
    }
    
    private func updateViewsStyle(with style: ContainerStyle) {
        hourlyForecastContainer.updateContainerStyle(with: style)
        dailyForecastContainer.updateContainerStyle(with: style)
        apparentTemperatureContainer.updateContainerStyle(with: style)
        windContainer.updateContainerStyle(with: style)
        relativeHumidityContainer.updateContainerStyle(with: style)
        precipitationSumContainer.updateContainerStyle(with: style)
    }
    
    func update(withGeocoding geocoding: Geocoding, weather: Weather?) {
        updateGeocodingViews(with: geocoding)
        
        guard let weather else { return }
        
        updateWeatherViews(with: weather)
    }
    
    private func updateGeocodingViews(with geocoding: Geocoding) {
        let locationName = geocoding.name
        geoNameLabel.setAttributedTextWithShadow(locationName)
    }
    
    private func updateWeatherViews(with weather: Weather) {
        let currentHourForecast = weather.obtainForecastForCurrentHour()
        let currentDayForecast = weather.obtainCurrentDayForecast()
        let nextDayForecast = weather.obtainDailyForecastFor(nextDays: 1).last

        updateMainInfoContainer(currentHourForecast: currentHourForecast, currentDayForecast: currentDayForecast)
        updateHourlyForecastContainer(weather: weather)
        updateDailyForecastContainer(weather: weather)
        updateApparentTemperatureContainer(currentHourForecast: currentHourForecast)
        updateWindContainer(currentHourForecast: currentHourForecast)
        updateRelativeHumidityContainer(currentHourForecast: currentHourForecast)
        updatePrecipitationSumContainer(currentDayForecast: currentDayForecast, nextDayForecast: nextDayForecast)
    }
    
    private func updateMainInfoContainer(currentHourForecast: HourForecast, currentDayForecast: DayForecast?) {
        let currentTemperature = currentHourForecast.temperature.real
        let currentDayTemperatureRange = currentDayForecast?.temperatureRange
        let currentWeatherCodeDescription = currentHourForecast.weatherCode.localizedDescription
        
        currentTemperatureLabel.setTemperature(currentTemperature)
        todayTemeperatureRangeContainer.setTemperature(range: currentDayTemperatureRange)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(currentWeatherCodeDescription)
    }
    
    private func updateHourlyForecastContainer(weather: Weather) {
        let hourlyForecastFor24Hours = weather.obtainHourlyForecastFor(nextHours: 24)
        hourlyForecastContainer.update(withHourlyForecastList: hourlyForecastFor24Hours)
    }
    
    private func updateDailyForecastContainer(weather: Weather) {
        let dailyForecastForWeek = weather.obtainDailyForecastFor(nextDays: 7)
        dailyForecastContainer.update(withDailyForecastList: dailyForecastForWeek)
    }
    
    private func updateApparentTemperatureContainer(currentHourForecast: HourForecast) {
        let currentHourTemperature = currentHourForecast.temperature
        apparentTemperatureContainer.update(withHourTemperature: currentHourTemperature)
    }
    
    private func updateWindContainer(currentHourForecast: HourForecast) {
        let wind = currentHourForecast.wind
        windContainer.update(withWind: wind)
    }
    
    private func updateRelativeHumidityContainer(currentHourForecast: HourForecast) {
        let relativeHumidity = currentHourForecast.relativeHumidity
        relativeHumidityContainer.update(withRelativeHumidity: relativeHumidity)
    }
    
    private func updatePrecipitationSumContainer(currentDayForecast: DayForecast?, nextDayForecast: DayForecast?) {
        let todayPrecipitationSum = currentDayForecast?.precipitationSum ?? 0
        let tomorrowPrecipitationSum = nextDayForecast?.precipitationSum ?? 0
        precipitationSumContainer.setup(withTodaySum: todayPrecipitationSum, tomorrowSum: tomorrowPrecipitationSum)
    }
    
    // MARK: - Views
    
    private func configureContentContainer() -> UIStackView {
        let container = UIStackView(arrangedSubviews: [
            mainInfoContainer,
            hourlyForecastContainer,
            dailyForecastContainer,
            apparentTemperatureAndWindHorizontalStack,
            relativeHumidityAndPrecipitationStack
        ])
        
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.spacing = contentSpacing
        
        return container
    }
    
    private func configureMainInfoContainer() -> UIStackView {
        let container = UIStackView(arrangedSubviews: [
            geoNameLabel,
            currentTemperatureLabel,
            todayTemeperatureRangeContainer,
            weatherCodeDescriptionLabel
        ])
        
        container.axis = .vertical
        container.alignment = .center
        container.setCustomSpacing(10, after: todayTemeperatureRangeContainer)
        
        return container
    }
    
    private func configureGeoNameLabel() -> UILabel {
        let label = UILabel()
        
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }
    
    private func configureCurrentTemperatureLabel() -> TemperatureLabel {
        let label = TemperatureLabel()

        label.font = UIFont.systemFont(ofSize: 60)
        label.textColor = .white

        return label
    }
    
    private func configureTodayTemperatureRangeContainer() -> TemperatureRangeContainer {
        let container = TemperatureRangeContainer()
        
        container.setColors(.white)
        
        return container
    }
    
    private func configureWeatherCodeDescriptionLabel() -> UILabel {
        let label = UILabel()
        
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }
    
    private func configureHorizontalContainerCouple(_ firstContainer: ContainerView, _ secondContainer: ContainerView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [firstContainer, secondContainer])
        
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        return stack
    }
}
