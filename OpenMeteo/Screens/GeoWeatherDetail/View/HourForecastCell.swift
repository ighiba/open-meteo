//
//  HourForecastCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit
import SnapKit

class HourForecastCell: UICollectionViewCell {
    
    static let reuseIdentifier = "hourForecastCell"
    
    static let width: CGFloat = 40
    static let height: CGFloat = 160
    
    private let horizontalOffset: CGFloat = 15
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setViews() {
        addSubview(hourLabel)
        addSubview(precipitationProbabilityLabel)
        addSubview(temperatureLabel)
        addSubview(weatherIconView)
        
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
    
    func configure(with hourForecast: HourForecast, for indexPath: IndexPath) {
        let nowString = NSLocalizedString("Now", comment: "")
        let hourLabelText = indexPath.row == 0 ? nowString : hourForecast.date.string(withFormat: "HH")
        let weatherType =  hourForecast.weatherCode.obtainWeatherType()
        
        hourLabel.setAttributedTextWithShadow(hourLabelText)
        temperatureLabel.setTemperature(hourForecast.temperature)
        precipitationProbabilityLabel.setPrecipitationProbability(hourForecast.precipitationProbability)
        weatherIconView.setIcon(for: weatherType, isDay: hourForecast.isDay)
    }
    
    // MARK: - Views
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        
        label.text = "12"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    lazy var precipitationProbabilityLabel: PrecipitationProbabilityLabel = {
        let label = PrecipitationProbabilityLabel()
        
        label.text = "0%"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(named: "PrecipitationLabel")
        
        return label
    }()
    
    lazy var temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    lazy var weatherIconView: WeatherIconView = WeatherIconView(weatherIcon: .sun)
}
