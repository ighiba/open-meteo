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
        self.addSubview(hourLabel)
        self.addSubview(temperatureLabel)
        
        hourLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(horizontalOffset)
            make.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(horizontalOffset)
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(with hourForecast: HourForecast) {
        hourLabel.text = hourForecast.time.string(withFormat: "hh")
        temperatureLabel.text = String(format: "%.0f", hourForecast.temperature) + "°"
        
        hourLabel.sizeToFit()
        temperatureLabel.sizeToFit()
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
    
}
