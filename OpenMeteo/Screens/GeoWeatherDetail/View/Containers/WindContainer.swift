//
//  WindContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class WindContainer: ContainerView {
    
    private let verticalSpacing: CGFloat = 5
    
    override var title: String { NSLocalizedString("Wind", comment: "") }
    
    // MARK: - Methods

    override func setupViews() {
        super.setupViews()
        
        addSubview(windSpeedLabel)
        addSubview(windDirectionLabel)

        windSpeedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.centerY).offset(verticalSpacing)
        }
        
        windDirectionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(snp.centerY).offset(verticalSpacing)
        }
    }
    
    func setup(withWind wind: Wind) {
        let windDirectionDescriptionShort = WindDirection.obtain(by: wind.direction)?.localizedDescriptionShort ?? "--"
        let windSpeedText = transfromIntoLocalizedText(windSpeed: wind.speed)
        
        windSpeedLabel.setAttributedTextWithShadow(windSpeedText)
        windDirectionLabel.setAttributedTextWithShadow(windDirectionDescriptionShort)
    }
    
    private func transfromIntoLocalizedText(windSpeed: Float) -> String {
        var measurement = Measurement(value: Double(windSpeed), unit: UnitSpeed.kilometersPerHour).converted(to: .metersPerSecond)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        measurement.value = measurement.value.rounded()
        
        return formatter.string(from: measurement)
    }
    
    // MARK: - Views
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        label.text = "--"
        
        return label
    }()
    
    private let windDirectionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        
        return label
    }()
}
