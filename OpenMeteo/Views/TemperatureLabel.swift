//
//  TemperatureLabel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import UIKit

class TemperatureLabel: UILabel {
    
    init(_ temperature: Float? = nil) {
        super.init(frame: .zero)
        if let temperature = temperature {
            setTemperature(temperature)
        } else {
            self.text = "--"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTemperature(_ temperature: Float) {
        self.text = String(format: "%.0f", temperature) + "°C"
        self.sizeToFit()
    }
}
