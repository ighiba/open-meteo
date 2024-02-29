//
//  TemperatureRangeContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit

final class TemperatureRangeContainer: UIView {
    
    let minTemperatureLabel: TemperatureLabelSymboled
    let maxTemperatureLabel: TemperatureLabelSymboled
    
    var preferredWidth: CGFloat { minTemperatureLabel.prefferedWidth + maxTemperatureLabel.prefferedWidth }
    
    // MARK: - Init
    
    init(withFontSize fontSize: CGFloat = 20) {
        self.minTemperatureLabel = TemperatureLabelSymboled(symbolName: "arrow.down", temperatureFontSize: fontSize)
        self.maxTemperatureLabel = TemperatureLabelSymboled(symbolName: "arrow.up", temperatureFontSize: fontSize)
        super.init(frame: .zero)
        self.setupViews()
        self.setPlaceholders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setupViews() {
        addSubview(minTemperatureLabel)
        addSubview(maxTemperatureLabel)

        minTemperatureLabel.setupConstraints(superview: self, toLeading: true)
        maxTemperatureLabel.setupConstraints(superview: self, toLeading: false)
    }
    
    func setColors(_ color: UIColor) {
        minTemperatureLabel.setColor(color)
        maxTemperatureLabel.setColor(color)
    }
    
    func setTemperature(range temperatureRange: TemperatureRange?) {
        guard let temperatureRange else { return }
        
        minTemperatureLabel.setTemperature(temperatureRange.min)
        maxTemperatureLabel.setTemperature(temperatureRange.max)
    }
    
    func setPlaceholders() {
        minTemperatureLabel.temperatureLabel.setPlaceholder()
        maxTemperatureLabel.temperatureLabel.setPlaceholder()
    }
}
