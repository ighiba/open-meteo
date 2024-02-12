//
//  PrecipitationSumContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class PrecipitationSumContainer: ContainerView {
    
    override var title: String { NSLocalizedString("Precipitation", comment: "") }
    
    // MARK: - Methods

    override func setupViews() {
        super.setupViews()
        addSubview(precipitationLabel)
        addSubview(descriptionLabel)

        precipitationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.85)
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
            make.top.equalTo(precipitationLabel.snp.bottom)
        }
    }

    func configure(with precipitationSum: Float, tomorrowPrecipitation: Float?) {
        let precipitationSumText = transfromIntoLocalizedText(precipitationSum)
        precipitationLabel.setAttributedTextWithShadow(precipitationSumText)

        guard let tomorrowPrecipitation = tomorrowPrecipitation else { return }
        let tomorrowPrecipitationText = transfromIntoLocalizedText(tomorrowPrecipitation)
        
        let localizedDescription: String
        if tomorrowPrecipitation.rounded() == 0 {
            localizedDescription = NSLocalizedString("No precipitation is expected tomorrow", comment: "")
        } else {
            localizedDescription = NSLocalizedString("Tomorrow, %@ of precipitation is expected", comment: "")
        }
        
        let descriptionText = String(format: localizedDescription, tomorrowPrecipitationText)
        descriptionLabel.setAttributedTextWithShadow(descriptionText)
        descriptionLabel.attributedStringSetMultilineText() 
    }
    
    private func transfromIntoLocalizedText(_ precipitationSum: Float) -> String {
        var measurement = Measurement(value: Double(precipitationSum), unit: UnitLength.millimeters)
        measurement.value = measurement.value.rounded()

        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        
        return formatter.string(from: measurement)
    }
    
    // MARK: - Views
    
    private let precipitationLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        label.text = "--"
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white.withAlphaComponent(0.5)
        
        return label
    }()
}
