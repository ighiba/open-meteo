//
//  HourForecastCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class HourForecastCell: UICollectionViewCell {
    
    static let reuseIdentifier = "hourForecastCell"
    
    static let width: CGFloat = 40
    static let height: CGFloat = 130
    
    private let horizontalOffset: CGFloat = 15
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func setViews() {
        self.addSubview(hourLabel)
        self.addSubview(temperatureLabel)
        self.addSubview(weatherIconView)
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(horizontalOffset)
            make.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(horizontalOffset - 5)
            make.centerX.equalToSuperview()
        }
        
        weatherIconView.snp.makeConstraints { make in
            make.width.equalTo(Self.width)
            make.height.equalTo(Self.width)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with hourForecast: HourForecast, for indexPath: IndexPath) {
        let hourLabelText = indexPath.row == 0 ? "Now" : hourForecast.date.string(withFormat: "HH")
        hourLabel.text = hourLabelText
        temperatureLabel.text = String(format: "%.0f", hourForecast.temperature) + "°"
        
        hourLabel.sizeToFit()
        temperatureLabel.sizeToFit()
        
        weatherIconView.setIcon(for: hourForecast.weatherCode.obtainWeatherType(), isDay: hourForecast.isDay)
    }
    
    // MARK: - Views
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        
        label.text = "12"
        label.font = UIFont.systemFont(ofSize: 17)
        label.sizeToFit()
        
        return label
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.text = "0" + "°"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        
        return label
    }()
    
    lazy var weatherIconView: WeatherIconView = WeatherIconView(weatherIcon: .sun)
    
}
