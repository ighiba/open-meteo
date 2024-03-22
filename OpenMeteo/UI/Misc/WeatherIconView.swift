//
//  WeatherIconView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

final class WeatherIconView: UIImageView {
    
    init(weatherIcon: WeatherIcon) {
        super.init(image: weatherIcon.image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIcon(for weatherCondition: Weather.Condition, isDay: Bool = true) {
        image = WeatherIcon.obtainIcon(for: weatherCondition, isDay: isDay).image
    }
}
