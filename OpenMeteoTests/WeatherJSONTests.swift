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
        let correctTime = dateFormatter.date(from: "2023-06-25T17:00:00+00:00")
        
        let weather = try decoder.decode(WeatherJSON.self, from: weatherJSONData).result
        let time = weather.obtainForecastForCurrentHour().date

        XCTAssertEqual(time, correctTime, "Wrong value decode result")
    }
    
    func testDecodeCurrentTemperature() throws {
        let weather = try decoder.decode(WeatherJSON.self, from: weatherJSONData).result
        let temperature = weather.obtainForecastForCurrentHour().temperature

        XCTAssertEqual(temperature, 21.0, "Wrong value decode result")
    }
}
