//
//  OpenMeteoTests.swift
//  OpenMeteoTests
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import XCTest
@testable import OpenMeteo

final class TitlesJSONTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testDecodeCurrentTime() throws {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = .withInternetDateTime
        let correctTime = dateFormatter.date(from: "2023-06-24T00:00:00+00:00")
        
        let weather = try decoder.decode(WeatherJSON.self, from: weatherJSONData).weather
        let time = weather.timedTemperatureList.first?.time

        XCTAssertEqual(time, correctTime, "Wrong value decode result")
    }
    
    func testDecodeCurrentTemperature() throws {
        let weather = try decoder.decode(WeatherJSON.self, from: weatherJSONData).weather
        let temperature = weather.timedTemperatureList.first?.temperature

        XCTAssertEqual(temperature, 20.3, "Wrong value decode result")
    }
    
}
