//
//  TemperatureRangeContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit

class TemperatureRangeContainer: UIView {
    
    lazy var minTemperatureLabel = TemperatureLabelSymboled(symbolName: "arrow.down")
    lazy var maxTemperatureLabel = TemperatureLabelSymboled(symbolName: "arrow.up")
    
    init() {
        super.init(frame: .zero)
        self.setTemperature(min: 0, max: 0)
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
    
    func setTemperature(min: Float, max: Float) {
        minTemperatureLabel.setTemperature(min)
        maxTemperatureLabel.setTemperature(max)
    }
}
