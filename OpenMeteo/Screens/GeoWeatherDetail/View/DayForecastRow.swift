//
//  DayForecastRow.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

final class DayForecastRow: UIView {
    
    static let height: CGFloat = 44
    
    private let verticalOffset: CGFloat = 20
    private let iconWidthHeight: CGFloat = 40
    
    // MARK: - Views
    
    lazy var dateLabel = configureDateLabel()
    lazy var precipitationProbabilityLabel = configurePrecipitationProbabilityLabel()
    private let weatherIconView = WeatherIconView(weatherIcon: .sun)
    private let temperatureRangeContainer = TemperatureRangeContainer()
    
    // MARK: - Init
    
    init(dayForecast: DayForecast) {
        super.init(frame: .zero)
        self.setupViews()
        self.setup(withDayForecast: dayForecast)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    private func setupViews() {
        temperatureRangeContainer.setColors(.white)
        
        addSubview(dateLabel)
        addSubview(precipitationProbabilityLabel)
        addSubview(weatherIconView)
        addSubview(temperatureRangeContainer)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(verticalOffset)
            make.centerY.equalToSuperview()
        }
        
        precipitationProbabilityLabel.snp.makeConstraints { make in
            make.height.equalTo(Self.height)
            make.width.equalTo(Self.height)
            make.trailing.equalTo(weatherIconView.snp.leading).offset(-verticalOffset / 2)
            make.centerY.equalToSuperview()
        }
        
        weatherIconView.snp.makeConstraints { make in
            make.width.equalTo(iconWidthHeight)
            make.height.equalTo(iconWidthHeight)
            make.trailing.equalTo(temperatureRangeContainer.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        temperatureRangeContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(verticalOffset / 4)
            make.width.equalTo(temperatureRangeContainer.preferredWidth)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setup(withDayForecast dayForecast: DayForecast) {
        let dateText = dayForecast.date.string(withFormat: "dd MMMM")
        let precipitationProbabilityMax = dayForecast.precipitationProbabilityMax
        let temperatureRange = dayForecast.temperatureRange
        let weatherCondition = dayForecast.weatherCode.obtainWeatherCondition()
        
        dateLabel.setAttributedTextWithShadow(dateText)
        precipitationProbabilityLabel.setPrecipitationProbability(precipitationProbabilityMax)
        temperatureRangeContainer.setTemperature(range: temperatureRange)
        weatherIconView.setIcon(for: weatherCondition)
    }

    private func configurePrecipitationProbabilityLabel() -> PrecipitationProbabilityLabel {
        let label = PrecipitationProbabilityLabel()
        
        label.text = "0%"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(named: "PrecipitationLabel")
        
        return label
    }

    private func configureDateLabel() -> UILabel {
        let label = UILabel()
        
        label.text = "01.01.2000"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }
}
