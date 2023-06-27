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
    private let temperatureContainerSize = CGSize(width: 100, height: 50)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        super.updateConstraints()
    }
    
    func setViews() {
        self.backgroundColor = .red
        self.layer.cornerRadius = Self.height / 5
        
        self.addSubview(geoNameLabel)
        currentTemperatureContainer.addSubview(currentTemperatureLabel)
        self.addSubview(currentTemperatureContainer)

        geoNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.centerY.equalToSuperview()
        }
        
        currentTemperatureContainer.snp.makeConstraints { make in
            make.width.equalTo(temperatureContainerSize.width)
            make.height.equalTo(temperatureContainerSize.height)
            make.trailing.equalToSuperview().inset(horizontalOffset)
            make.centerY.equalToSuperview()
        }
        
        currentTemperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Methods
    
    func configure(with geoWeather: GeoWeather) {
        geoNameLabel.text = geoWeather.geocoding.name
        currentTemperatureLabel.setTemperature(geoWeather.weather.obtainForecastForCurrentHour().temperature)
    }
    
    // MARK: - Views
    
    private let geoNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Location name"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.sizeToFit()
        
        return label
    }()
    
    lazy var currentTemperatureContainer: UIView = {
        let container = UIView()
        
        container.backgroundColor = .systemGray4
        container.layer.cornerRadius = temperatureContainerSize.height / 5
        
        return container
    }()
    
    let currentTemperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 20)

        return label
    }()
}
