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
    
    var preferredContainersStyle: ContainerStyle = .light {
        didSet {
            updateViewsStyle(with: preferredContainersStyle)
        }
    }
    
    private let contentSpacing: CGFloat = 25
    private var containerCoupleInset: CGFloat { contentSpacing / 4 }
    private let containerCoupleHeightMultiplier: CGFloat = 0.5
    private let contentContainerWidthMultiplier: CGFloat = 0.9
    private let todayTemperatureRangeContainerHeight: CGFloat = 25
    
    // MARK: - Views
    
    private lazy var contentContainer = configureContentContainer()
    
    private lazy var mainInfoContainer = configureMainInfoContainer()
    private lazy var geoNameLabel = configureGeoNameLabel()
    private lazy var currentTemperatureLabel = configureCurrentTemperatureLabel()
    private lazy var todayTemeperatureRangeContainer = configureTodayTemperatureRangeContainer()
    private lazy var weatherCodeDescriptionLabel = configureWeatherCodeDescriptionLabel()
    
    private let hourlyForecastContainer = HourlyForecastContainer()
    private let dailyForecastContainer = DailyForecastContainer()
    
    private lazy var apparentTemperatureAndWindHorizontalStack = configureHorizontalContainerCouple(apparentTemperatureContainer, windContainer)
    private let apparentTemperatureContainer = ApparentTemperatureContainer()
    private let windContainer = WindContainer()
    
    private lazy var relativeHumidityAndPrecipitationStack = configureHorizontalContainerCouple(relativeHumidityContainer, precipitationSumContainer)
    private let relativeHumidityContainer = RelativeHumidityContainer()
    private let precipitationSumContainer = PrecipitationSumContainer()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func update(
        withLocationName locationName: String,
        currentHourForecast: HourForecast,
        currentDayForecast: DayForecast?,
        nextDayForecast: DayForecast?,
        hourlyForecastFor24Hours: [HourForecast],
        dailyForecastForWeek: [DayForecast]
    ) {
        updateGeoNameLabel(locationName: locationName)
        updateMainInfoContainer(currentHourForecast: currentHourForecast, currentDayForecast: currentDayForecast)
        updateHourlyForecastContainer(hourlyForecastFor24Hours: hourlyForecastFor24Hours)
        updateDailyForecastContainer(dailyForecastForWeek: dailyForecastForWeek)
        updateApparentTemperatureContainer(currentHourForecast: currentHourForecast)
        updateWindContainer(currentHourForecast: currentHourForecast)
        updateRelativeHumidityContainer(currentHourForecast: currentHourForecast)
        updatePrecipitationSumContainer(currentDayForecast: currentDayForecast, nextDayForecast: nextDayForecast)
    }
    
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

    private func updateGeoNameLabel(locationName: String) {
        geoNameLabel.setAttributedTextWithShadow(locationName)
    }
    
    private func updateMainInfoContainer(currentHourForecast: HourForecast, currentDayForecast: DayForecast?) {
        let currentTemperature = currentHourForecast.temperature.real
        let currentDayTemperatureRange = currentDayForecast?.temperatureRange
        let currentWeatherCodeDescription = currentHourForecast.weatherCode.localizedDescription
        
        currentTemperatureLabel.setTemperature(currentTemperature)
        todayTemeperatureRangeContainer.setTemperature(range: currentDayTemperatureRange)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(currentWeatherCodeDescription)
    }
    
    private func updateHourlyForecastContainer(hourlyForecastFor24Hours: [HourForecast]) {
        hourlyForecastContainer.update(withHourlyForecastList: hourlyForecastFor24Hours)
    }

    private func updateDailyForecastContainer(dailyForecastForWeek: [DayForecast]) {
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
        precipitationSumContainer.update(withTodaySum: todayPrecipitationSum, tomorrowSum: tomorrowPrecipitationSum)
    }
    
    // MARK: - Views Methods
    
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
