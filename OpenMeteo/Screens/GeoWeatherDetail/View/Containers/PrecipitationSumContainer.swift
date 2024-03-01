//
//  PrecipitationSumContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class PrecipitationSumContainer: ContainerView {
    
    private let verticalOffset: CGFloat = -5
    private let tomorrowPrecipitationLabelWidthMultiplier: CGFloat = 0.85
    
    private let noPrecipitationExpectedFormat = NSLocalizedString("No precipitation is expected tomorrow", comment: "")
    private let precipitationExpectedFormat = NSLocalizedString("Tomorrow, %@ of precipitation is expected", comment: "")
    
    override var title: String { NSLocalizedString("Precipitation", comment: "") }
    
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

    func setup(withTodaySum todayPrecipitationSum: Float, tomorrowSum tomorrowPrecipitationSum: Float) {
        setupTodayPrecipitationLabel(todayPrecipitationSum: todayPrecipitationSum)
        setupTomorrowPrecipitationLabel(tomorrowPrecipitationSum: tomorrowPrecipitationSum)
    }
    
    private func setupTodayPrecipitationLabel(todayPrecipitationSum: Float) {
        let todayPrecipitationText = transfromIntoLocalizedText(precipitationSum: todayPrecipitationSum)
        todayPrecipitationLabel.setAttributedTextWithShadow(todayPrecipitationText)
    }
    
    private func setupTomorrowPrecipitationLabel(tomorrowPrecipitationSum: Float) {
        let tomorrowPrecipitationText = configureTomorrowPrecipitationText(tomorrowPrecipitationSum: tomorrowPrecipitationSum)
        tomorrowPrecipitationLabel.setAttributedTextWithShadow(tomorrowPrecipitationText)
        tomorrowPrecipitationLabel.attributedStringSetMultilineText()
    }
    
    private func configureTomorrowPrecipitationText(tomorrowPrecipitationSum: Float) -> String {
        let tomorrowPrecipitationText = transfromIntoLocalizedText(precipitationSum: tomorrowPrecipitationSum)
        let isPrecipitationExpected = tomorrowPrecipitationSum.rounded() != 0
        let format = isPrecipitationExpected ? precipitationExpectedFormat : noPrecipitationExpectedFormat
        
        return String(format: format, tomorrowPrecipitationText)
    }
    
    private func transfromIntoLocalizedText(precipitationSum: Float) -> String {
        var measurement = Measurement(value: Double(precipitationSum), unit: UnitLength.millimeters)
        measurement.value = measurement.value.rounded()

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
