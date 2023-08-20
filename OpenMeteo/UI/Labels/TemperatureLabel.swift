//
//  TemperatureLabel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class TemperatureLabel: UILabel {
    
    private var showTemperatureUnit: Bool
    
    init(_ temperature: Float? = nil, withTemperatureUnit: Bool = false) {
        self.showTemperatureUnit = withTemperatureUnit
        super.init(frame: .zero)
        if let temperature = temperature {
            setTemperature(temperature)
        } else {
            setPlaceholder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTemperature(_ temperature: Float) {
        let temperatureUnit = showTemperatureUnit ? "C" : ""
        let newText = String(format: "%.0f", temperature) + "°\(temperatureUnit)"
        setAttributedTextWithShadow(newText)
    }
    
    func setPlaceholder() {
        setAttributedTextWithShadow("--")
    }
}
