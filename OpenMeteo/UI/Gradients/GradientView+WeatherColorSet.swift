//
//  GradientView+WeatherColorSet.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import Foundation

extension GradientView {
    func setColors(weatherColorSet: WeatherColorSet) {
        let topColor = weatherColorSet.topColor
        let bottomColor = weatherColorSet.bottomColor
        setColors(start: topColor, end: bottomColor)
    }
}
