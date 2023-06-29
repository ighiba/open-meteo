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
        self.addSubview(contentContainer)

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

        self.contentLayoutGuide.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(contentContainer.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    func configure(with geoWeather: GeoWeather) {
        geoNameLabel.setAttributedTextWithShadow( geoWeather.geocoding.name)
        currentTemperatureLabel.setTemperature(geoWeather.weather.obtainForecastForCurrentHour().temperature)
        todayMinMaxTemeperatureRangeContainer.setTemperature(
            min: geoWeather.weather.currentDayMinTemperature,
            max: geoWeather.weather.currentDayMaxTemperature
        )
        weatherCodeDescriptionLabel.text = geoWeather.weather.currentWeatherCode.localizedDescription
        hourlyForecastCollectionView.configure(with: geoWeather.weather.obtainHourlyForecastFor(nextHours: 24))
        dailyForecastContainer.configure(with: geoWeather.weather.obtainDailyForecastFor(nextDays: 7))
    }
    
    // MARK: - Views
    
    lazy var contentContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [
            mainInfoContainer,
            hourlyForecastCollectionView,
            dailyForecastContainer
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
        container.spacing = 10
        
        return container
    }()
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()

        label.font = UIFont.systemFont(ofSize: 50)
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
    
    private let hourlyForecastCollectionView = HourlyForecastCollectionView()
    
    private let dailyForecastContainer = DailyForecastContainer()
}
