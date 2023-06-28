//
//  HourForecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct HourForecast: DatedForecast {
    var date: Date
    var weatherCode: Int16
    var temperature: Float
}
