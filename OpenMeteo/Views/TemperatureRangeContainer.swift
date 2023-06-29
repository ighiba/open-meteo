//
//  TemperatureRangeContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit

class TemperatureRangeContainer: UIView {
    
    var minTemperatureLabel: TemperatureLabelSymboled
    var maxTemperatureLabel: TemperatureLabelSymboled
    
    var preferredWidth: CGFloat {
        return minTemperatureLabel.prefferedWidth + maxTemperatureLabel.prefferedWidth
    }
    
    init(withFontSize fontSize: CGFloat = 20) {
        self.minTemperatureLabel = TemperatureLabelSymboled(symbolName: "arrow.down", temperatureFontSize: fontSize)
        self.maxTemperatureLabel = TemperatureLabelSymboled(symbolName: "arrow.up", temperatureFontSize: fontSize)
        super.init(frame: .zero)
        setTemperature(min: 0, max: 0)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViews() {
        self.addSubview(minTemperatureLabel)
        self.addSubview(maxTemperatureLabel)

        minTemperatureLabel.makeConstraints(superview: self, toLeading: true)
        maxTemperatureLabel.makeConstraints(superview: self, toLeading: false)
    }
    
    func setColors(_ color: UIColor) {
        minTemperatureLabel.setColors(color)
        maxTemperatureLabel.setColors(color)
    }
    
    func setTemperature(min: Float, max: Float) {
        minTemperatureLabel.setTemperature(min)
        maxTemperatureLabel.setTemperature(max)
    }
}
