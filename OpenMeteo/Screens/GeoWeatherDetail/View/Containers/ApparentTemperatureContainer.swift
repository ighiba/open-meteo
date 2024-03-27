//
//  ApparentTemperatureContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class ApparentTemperatureContainer: ContainerView {
    
    override var title: String { NSLocalizedString("Feels like", comment: "") }
    
    private let verticalOffset: CGFloat = -5
    private let descriptionLabelWidthMultiplier: CGFloat = 0.85
    
    // MARK: - Methods

    override func setupViews() {
        super.setupViews()
        
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)

        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(verticalOffset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(descriptionLabelWidthMultiplier)
            make.bottom.equalToSuperview().offset(verticalOffset)
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom)
        }
    }

    func update(withHourTemperature hourTemperature: HourTemperature) {
        let apparentTemperature = hourTemperature.apparent
        let descriptionText = hourTemperature.perception.localizedDescription

        temperatureLabel.setTemperature(apparentTemperature)
        descriptionLabel.setAttributedTextWithShadow(descriptionText)
    }
    
    // MARK: - Views
    
    private let temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.5)
        
        return label
    }()
}
