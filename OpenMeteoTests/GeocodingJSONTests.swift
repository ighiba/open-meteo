//
//  GeocodingJSONTests.swift
//  OpenMeteoTests
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import XCTest
@testable import OpenMeteo

final class GeocodingJSONTests: XCTestCase {
    
    let decoder = JSONDecoder()
    
    func testDecodeCurrentId() throws {
        let geocoding = try decoder.decode(GeocodingJSON.self, from: geocodingJSONData).result.first
        let id = geocoding?.id

        XCTAssertEqual(id, 524901, "Wrong value decode result")
    }
    
    func testDecodeCurrentName() throws {
        let geocoding = try decoder.decode(GeocodingJSON.self, from: geocodingJSONData).result.first
        let name = geocoding?.name

        XCTAssertEqual(name, "Moscow", "Wrong value decode result")
    }
    
    func testDecodeCurrentLatitude() throws {
        let geocoding = try decoder.decode(GeocodingJSON.self, from: geocodingJSONData).result.first
        let latitude = geocoding?.latitude

        XCTAssertEqual(latitude, 55.75222, "Wrong value decode result")
    }
    
    func testDecodeCurrentLongitude() throws {
        let geocoding = try decoder.decode(GeocodingJSON.self, from: geocodingJSONData).result.first
        let longitude = geocoding?.longitude

        XCTAssertEqual(longitude, 37.61556, "Wrong value decode result")
    }
    
    func testDecodeCurrentCountry() throws {
        let geocoding = try decoder.decode(GeocodingJSON.self, from: geocodingJSONData).result.first
        let country = geocoding?.country

        XCTAssertEqual(country, "Russia", "Wrong value decode result")
    }
}
