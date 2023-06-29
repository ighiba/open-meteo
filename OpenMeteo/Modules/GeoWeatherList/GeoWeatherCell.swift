//
//  GeoWeatherCell.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit
import SnapKit

class GeoWeatherCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "geoWeatherCell"
    static let height: CGFloat = 100
    
    private let horizontalOffset: CGFloat = 20
    
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
        self.layer.cornerRadius = Self.height / 5
        backgroundGradientView.layer.cornerRadius = Self.height / 5
        backgroundGradientView.layer.masksToBounds = true
        
        self.addSubview(backgroundGradientView)
        self.addSubview(geoNameLabel)
        self.addSubview(weatherCodeDescriptionLabel)
        self.addSubview(currentTemperatureLabel)
        self.addSubview(todayMinMaxTemeperatureRangeContainer)

        backgroundGradientView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        geoNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.top.equalTo(currentTemperatureLabel).offset(10)
        }
        
        weatherCodeDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(geoNameLabel)
            make.centerY.equalTo(todayMinMaxTemeperatureRangeContainer)
        }

        currentTemperatureLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(horizontalOffset)
            make.centerY.equalToSuperview().offset(-horizontalOffset / 2)
        }
        
        todayMinMaxTemeperatureRangeContainer.snp.makeConstraints { make in
            make.top.equalTo(currentTemperatureLabel.snp.bottom)
            make.centerX.equalTo(currentTemperatureLabel)
            make.width.equalTo(todayMinMaxTemeperatureRangeContainer.preferredWidth)
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Methods
    
    func configure(with geoWeather: GeoWeather) {
        updateBackgroundView(with: geoWeather)
        geoNameLabel.setAttributedTextWithShadow(geoWeather.geocoding.name)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(geoWeather.weather.currentWeatherCode.localizedDescription)
        currentTemperatureLabel.setTemperature(geoWeather.weather.obtainForecastForCurrentHour().temperature)
        todayMinMaxTemeperatureRangeContainer.setTemperature(
            min: geoWeather.weather.currentDayMinTemperature,
            max: geoWeather.weather.currentDayMaxTemperature
        )
    }

    func updateBackgroundView(with geoWeather: GeoWeather) {
        let skyType = geoWeather.weather.obtainSkyType()
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundGradientView.setColors(weatherColorSet: colorSet)
    }
    
    // MARK: - Views
    
    private var backgroundGradientView = GradientView()
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Location name"
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let weatherCodeDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white

        return label
    }()
    
    private let todayMinMaxTemeperatureRangeContainer: TemperatureRangeContainer = {
        let fontSize: CGFloat = 15
        let container = TemperatureRangeContainer(withFontSize: fontSize)
        
        container.minTemperatureLabel.temperatureLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        container.maxTemperatureLabel.temperatureLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .light)
        
        container.setColors(.white)
        
        return container
    }()
}
