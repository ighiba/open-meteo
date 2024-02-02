//
//  TemperatureLabel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class TemperatureLabel: UILabel {
    
    private var showTemperatureUnit: Bool
    
    // MARK: - Init
    
    init(_ temperature: Float? = nil, showTemperatureUnit: Bool = false) {
        self.showTemperatureUnit = showTemperatureUnit
        super.init(frame: .zero)
        if let temperature = temperature {
            self.setTemperature(temperature)
        } else {
            self.setPlaceholder()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setTemperature(_ temperature: Float) {
        let temperatureUnit = showTemperatureUnit ? "C" : ""

        let roundedTemperature = temperature.rounded(.toNearestOrEven)
        let formattedTemperature = String(format: "%.0f", roundedTemperature).replacingOccurrences(of: "-0", with: "0")
        let text = formattedTemperature + "°\(temperatureUnit)"
        setAttributedTextWithShadow(text)
    }
    
    func setPlaceholder() {
        setAttributedTextWithShadow("--")
    }
}
