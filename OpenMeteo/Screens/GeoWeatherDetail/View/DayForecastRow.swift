//
//  DayForecastRow.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

class DayForecastRow: UIView {
    
    static let height: CGFloat = 44
    
    private let verticalOffset: CGFloat = 20
    private let iconWidthHeight: CGFloat = 40
    
    // MARK: - Views
    
    lazy var dateLabel = configureDateLabel()
    lazy var precipitationProbabilityLabel = configurePrecipitationProbabilityLabel()
    private let weatherIconView = WeatherIconView(weatherIcon: .sun)
    private let minMaxTemeperatureRangeContainer = TemperatureRangeContainer()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        minMaxTemeperatureRangeContainer.setColors(.white)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    
    private func setViews() {
        addSubview(dateLabel)
        addSubview(precipitationProbabilityLabel)
        addSubview(weatherIconView)
        addSubview(minMaxTemeperatureRangeContainer)
        
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
            make.trailing.equalTo(minMaxTemeperatureRangeContainer.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        minMaxTemeperatureRangeContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(verticalOffset / 4)
            make.width.equalTo(minMaxTemeperatureRangeContainer.preferredWidth)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with forecast: DayForecast) {
        let dateText = forecast.date.string(withFormat: "dd MMMM")
        let precipitationMax = forecast.precipitationProbabilityMax
        let weatherType = forecast.weatherCode.obtainWeatherType()
        
        dateLabel.setAttributedTextWithShadow(dateText)
        precipitationProbabilityLabel.setPrecipitationProbability(precipitationMax)
        minMaxTemeperatureRangeContainer.setTemperature(min: forecast.temperature.min, max: forecast.temperature.max)
        weatherIconView.setIcon(for: weatherType)
    }

    func configurePrecipitationProbabilityLabel() -> PrecipitationProbabilityLabel {
        let label = PrecipitationProbabilityLabel()
        
        label.text = "0%"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = UIColor(named: "PrecipitationLabel")
        
        return label
    }

    func configureDateLabel() -> UILabel {
        let label = UILabel()
        
        label.text = "01.01.2000"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }
}
