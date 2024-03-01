//
//  HourForecastCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

final class HourForecastCell: UICollectionViewCell {
    
    static let reuseIdentifier = "hourForecastCell"
    
    static let width: CGFloat = 40
    static let height: CGFloat = 160
    
    private let horizontalOffset: CGFloat = 15
    
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
        addSubview(hourLabel)
        addSubview(precipitationProbabilityLabel)
        addSubview(weatherIconView)
        addSubview(temperatureLabel)
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(horizontalOffset)
            make.centerX.equalToSuperview()
        }
        
        precipitationProbabilityLabel.snp.makeConstraints { make in
            make.bottom.equalTo(weatherIconView.snp.top).offset(-2)
            make.centerX.equalToSuperview()
        }
        
        weatherIconView.snp.makeConstraints { make in
            make.width.equalTo(Self.width)
            make.height.equalTo(Self.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(snp.centerY).offset(-horizontalOffset)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(horizontalOffset - 5)
            make.centerX.equalToSuperview()
        }
    }
    
    func update(withHourForecast hourForecast: HourForecast, isNow: Bool) {
        let hourText = configureHourText(date: hourForecast.date, isNow: isNow)
        let weatherType = hourForecast.weatherCode.obtainWeatherType()
        
        hourLabel.setAttributedTextWithShadow(hourText)
        temperatureLabel.setTemperature(hourForecast.temperature.real)
        precipitationProbabilityLabel.setPrecipitationProbability(hourForecast.precipitationProbability)
        weatherIconView.setIcon(for: weatherType, isDay: hourForecast.isDay)
    }
    
    private func configureHourText(date: Date, isNow: Bool) -> String {
        if isNow {
            return NSLocalizedString("Now", comment: "")
        } else {
            return date.string(withFormat: "HH")
        }
    }
    
    // MARK: - Views
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        
        label.text = "00"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let precipitationProbabilityLabel: PrecipitationProbabilityLabel = {
        let label = PrecipitationProbabilityLabel()
        
        label.text = "0%"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "PrecipitationLabel")
        
        return label
    }()
    
    private let temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let weatherIconView: WeatherIconView = WeatherIconView(weatherIcon: .sun)
}
