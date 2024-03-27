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
    
    private let verticalOffset: CGFloat = -5
    private let tomorrowPrecipitationLabelWidthMultiplier: CGFloat = 0.85
    
    private let noPrecipitationExpectedFormat = NSLocalizedString("No precipitation is expected tomorrow", comment: "")
    private let precipitationExpectedFormat = NSLocalizedString("Tomorrow, %@ of precipitation is expected", comment: "")
    
    // MARK: - Methods

    override func setupViews() {
        super.setupViews()
        
        addSubview(todayPrecipitationLabel)
        addSubview(tomorrowPrecipitationLabel)

        todayPrecipitationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(verticalOffset * 2)
        }
        
        tomorrowPrecipitationLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(tomorrowPrecipitationLabelWidthMultiplier)
            make.bottom.equalToSuperview().offset(verticalOffset)
            make.centerX.equalToSuperview()
            make.top.equalTo(todayPrecipitationLabel.snp.bottom)
        }
    }

    func update(withTodaySum todayPrecipitationSum: Float, tomorrowSum tomorrowPrecipitationSum: Float) {
        updateTodayPrecipitationLabel(todayPrecipitationSum: todayPrecipitationSum)
        updateTomorrowPrecipitationLabel(tomorrowPrecipitationSum: tomorrowPrecipitationSum)
    }
    
    private func updateTodayPrecipitationLabel(todayPrecipitationSum: Float) {
        let todayPrecipitationText = transformIntoLocalizedText(precipitationSum: todayPrecipitationSum)
        todayPrecipitationLabel.setAttributedTextWithShadow(todayPrecipitationText)
    }
    
    private func updateTomorrowPrecipitationLabel(tomorrowPrecipitationSum: Float) {
        let isPrecipitationExpected = tomorrowPrecipitationSum.rounded() != 0
        let format = isPrecipitationExpected ? precipitationExpectedFormat : noPrecipitationExpectedFormat
        let localizedText = transformIntoLocalizedText(precipitationSum: tomorrowPrecipitationSum)
        let tomorrowPrecipitationText = String(format: format, localizedText)
        
        tomorrowPrecipitationLabel.setAttributedTextWithShadow(tomorrowPrecipitationText)
        tomorrowPrecipitationLabel.attributedStringSetMultilineText()
    }
    
    private func transformIntoLocalizedText(precipitationSum: Float) -> String {
        let value = Double(precipitationSum).rounded()
        let measurement = Measurement(value: value, unit: UnitLength.millimeters)

        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        
        return formatter.string(from: measurement)
    }
    
    // MARK: - Views
    
    private let todayPrecipitationLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        label.text = "--"
        
        return label
    }()
    
    private let tomorrowPrecipitationLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white.withAlphaComponent(0.5)
        
        return label
    }()
}
