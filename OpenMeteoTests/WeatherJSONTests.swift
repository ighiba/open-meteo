//
//  WeatherJSONTests.swift
//  OpenMeteoTests
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import XCTest
@testable import OpenMeteo

final class WeatherJSONTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testDecodeCurrentTime() throws {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withInternetDateTime
        let correctTime = dateFormatter.date(from: "2024-03-04T18:15:00+00:00")
        
        let weather = try decoder.decode(WeatherJSON.self, from: weatherJSONData).result
        let weatherService = WeatherServiceImpl(weather: weather)
        let time = weatherService.currentHourForecast.date

        XCTAssertEqual(time, correctTime, "Wrong value decode result")
    }
    
    func testDecodeCurrentTemperature() throws {
        let weather = try decoder.decode(WeatherJSON.self, from: weatherJSONData).result
        let weatherService = WeatherServiceImpl(weather: weather)
        let temperature = weatherService.currentHourForecast.temperature.real

        XCTAssertEqual(temperature, 0.2, "Wrong value decode result")
    }
}
