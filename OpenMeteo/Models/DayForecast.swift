//
//  DayForecast.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import Foundation

struct DayForecast {
    
    var date: Date
    var forecastByHour: [HourForecast]
    var minTemperature: Float {
        return forecastByHour.map { $0.temperature }.min() ?? 0
    }
    var maxTemperature: Float {
        return forecastByHour.map { $0.temperature }.max() ?? 0
    }
    
    static func transform(from hourForecasts: [HourForecast]) -> [DayForecast] {
        var dayForecasts: [DayForecast] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"

        var processedDates: [String] = []
        for hourForecast in hourForecasts {
            let processingDate = dateFormatter.string(from: hourForecast.time)
            guard !processedDates.contains(processingDate) else { continue }
            let hourForecastsForDate = hourForecasts.filter({ dateFormatter.string(from: $0.time) == processingDate })
                                           

            let date = hourForecasts.first { dateFormatter.string(from: $0.time) == processingDate }?.time ?? Date()
            
            dayForecasts.append(DayForecast(date: date, forecastByHour: hourForecastsForDate))
            processedDates.append(processingDate)
        }

        return dayForecasts
    }
}
