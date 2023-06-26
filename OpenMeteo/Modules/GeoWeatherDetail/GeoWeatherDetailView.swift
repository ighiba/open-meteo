//
//  GeoWeatherDetailView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

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
            make.top.equalToSuperview().offset(spacing)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }

        hourForecastCollectionView.snp.makeConstraints { make in
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
        geoNameLabel.text = geoWeather.geocoding.name
        currentTemperatureLabel.setTemperature(geoWeather.weather.current.temperature)
        hourForecastCollectionView.configure(with: geoWeather.weather.obtainHourlyForecastForCurrentDay())
        dayForecastContainer.configure(with: geoWeather.weather.forecastByDay)
    }
    
    // MARK: - Views
    
    lazy var contentContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews:[
            mainInfoContainer,
            hourForecastCollectionView,
            dayForecastContainer
        ])
        
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.spacing = spacing
        
        return container
    }()
    
    lazy var mainInfoContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [geoNameLabel, currentTemperatureLabel])
        
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 10
        
        return container
    }()
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "..."
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.sizeToFit()
        
        return label
    }()
    
    private let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()

        label.font = UIFont.systemFont(ofSize: 40)

        return label
    }()
    
    private let hourForecastCollectionView = HourForecastCollectionView()
    
    private let dayForecastContainer = DayForecastContainer()
}
