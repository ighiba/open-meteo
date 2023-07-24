//
//  WindContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class WindContainer: ContainerView {
    
    override var containerName: String {
        return NSLocalizedString("Wind", comment: "")
    }

    override func setViews() {
        super.setViews()
        self.addSubview(windSpeedLabel)
        self.addSubview(windDirectionLabel)

        windSpeedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(5)
        }
        
        windDirectionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(5)
        }
    }
    
    func configure(with wind: Wind) {
        let windDirectionDescriptionShort = WindDirection.obtain(by: wind.direction)?.localizedDescriptionShort ?? "--"
        let windSpeedText = transfromIntoLocalizedText(wind.speed)
        
        windSpeedLabel.setAttributedTextWithShadow(windSpeedText)
        windDirectionLabel.setAttributedTextWithShadow(windDirectionDescriptionShort)
    }
    
    private func transfromIntoLocalizedText(_ windSpeed: Float) -> String {
        var measurement = Measurement(value: Double(windSpeed), unit: UnitSpeed.kilometersPerHour).converted(to: .metersPerSecond)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        measurement.value = measurement.value.rounded()
        
        return formatter.string(from: measurement)
    }
    
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
