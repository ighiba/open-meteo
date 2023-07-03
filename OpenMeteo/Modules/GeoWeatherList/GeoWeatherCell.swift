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
    
    var longTapEndedCallback: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout

    func setViews() {
        self.layer.cornerRadius = Self.height / 5
        backgroundGradientView.layer.cornerRadius = Self.height / 5
        backgroundGradientView.layer.masksToBounds = true
        
        setBackgroundPlaceholder()
        
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
            make.trailing.equalTo(todayMinMaxTemeperatureRangeContainer.snp.leading)
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
        geoNameLabel.text = geoWeather.geocoding.name
        guard let weather = geoWeather.weather else { return }
        updateBackgroundView(with: weather)
        weatherCodeDescriptionLabel.setAttributedTextWithShadow(weather.currentWeatherCode.localizedDescription)
        currentTemperatureLabel.setTemperature(weather.obtainForecastForCurrentHour().temperature)
        todayMinMaxTemeperatureRangeContainer.setTemperature(
            min: weather.currentDayMinTemperature,
            max: weather.currentDayMaxTemperature
        )
    }

    func updateBackgroundView(with weather: Weather) {
        let skyType = weather.obtainSkyType()
        let colorSet = WeatherColorSet.obtainColorSet(fromSkyType: skyType)
        backgroundGradientView.setColors(weatherColorSet: colorSet)
    }
    
    func setBackgroundPlaceholder() {
        backgroundGradientView.setColors(weatherColorSet: .clearSky)
    }
    
    private func setGestureRecognizers() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent))
        longPress.minimumPressDuration = 0.1
        self.addGestureRecognizer(longPress)
    }
    
    @objc func longPressEvent(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            animateTapBegin()
        } else if sender.state == .ended {
            amimateTapEnded()
        }
    }

    private func animateTapBegin() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func amimateTapEnded() {
        UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            self.transform = .identity
        }) { [weak self] _ in
            self?.longTapEndedCallback?()
        }
    }
    
    // MARK: - Views
    
    private var backgroundGradientView = GradientView(endPoint: CGPoint(x: 0.5, y: 1.5))
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Location name"
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        label.sizeToFit()
        
        return label
    }()
    
    private let weatherCodeDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "..."
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
