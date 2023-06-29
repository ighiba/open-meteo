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
    private let weatherIconView = WeatherIconView(weatherIcon: .sun)
    private let temperatureRangeContainer = TemperatureRangeContainer()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    
    private func setViews() {
        self.addSubview(dateLabel)
        self.addSubview(weatherIconView)
        self.addSubview(temperatureRangeContainer)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(verticalOffset)
            make.centerY.equalToSuperview()
        }
        
        weatherIconView.snp.makeConstraints { make in
            make.width.equalTo(iconWidthHeight)
            make.height.equalTo(iconWidthHeight)
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalToSuperview()
        }
        
        temperatureRangeContainer.snp.makeConstraints { make in
            make.leading.equalTo(weatherIconView.snp.trailing).offset(verticalOffset / 4)
            make.trailing.equalToSuperview().inset(verticalOffset)
            make.centerY.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with forecast: DayForecast) {
        dateLabel.text = forecast.date.string(withFormat: "dd MMMM")
        dateLabel.sizeToFit()

        temperatureRangeContainer.setTemperature(min: forecast.minTemperature, max: forecast.maxTemperature)
        weatherIconView.setIcon(for: forecast.weatherCode.obtainWeatherType())
    }

    func configureDateLabel() -> UILabel {
        let label = UILabel()
        label.text = "01.01.2000"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }
}

