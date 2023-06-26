//
//  ForecastContainerRow.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class ForecastRow: UIView {
    
    static let height: CGFloat = 44
    
    private let verticalOffset: CGFloat = 20
    
    init() {
        super.init(frame: .zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        self.addSubview(dateLabel)
        self.addSubview(temperatureRangeLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(verticalOffset)
            make.centerY.equalToSuperview()
        }

        temperatureRangeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(verticalOffset)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with forecast: DayForecast) {
        dateLabel.text = forecast.date.string(withFormat: "dd MMMM")
        temperatureRangeLabel.text = "\(forecast.minTemperature)°...\(forecast.maxTemperature)°"
        
        dateLabel.sizeToFit()
        temperatureRangeLabel.sizeToFit()
    }
    
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.text = "01.01.2000"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        
        return label
    }()
    
    private let temperatureRangeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "12°...23°"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        
        return label
    }() 
}


