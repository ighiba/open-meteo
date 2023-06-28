//
//  WeatherIconView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

class WeatherIconView: UIImageView {
    
    convenience init(weatherIcon: WeatherIcon) {
        self.init(image: weatherIcon.image)
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIcon(for weatherType: WeatherType, isDay: Bool = true) {
        self.image = WeatherIcon.obtainIcon(for: weatherType, isDay: isDay).image
    }
}
