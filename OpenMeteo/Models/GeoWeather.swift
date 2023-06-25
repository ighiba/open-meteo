//
//  GeoWeather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct GeoWeather: Identifiable {
    var id: Int
    var geocoding: Geocoding
    var weather: Weather
}

#if DEBUG

let geoMoscow = Geocoding(id: 524901, name: "Moscow", latitude: 55.75222, longitude: 37.61556, country: "Russia")
let weatherMoscow = Weather(timedTemperatureList: [
    TimedTemperature(time: Date(timeIntervalSinceNow: 0), temperature: 23.7),
    TimedTemperature(time: Date(timeIntervalSinceNow: 3600), temperature: 25.2),
    TimedTemperature(time: Date(timeIntervalSinceNow: 7200), temperature: 26.1),
    TimedTemperature(time: Date(timeIntervalSinceNow: 10800), temperature: 25.8),
])

let geoPskov = Geocoding(id: 504341, name: "Pskov", latitude: 57.8136, longitude: 28.3496, country: "Russia")
let weatherPskov = Weather(timedTemperatureList: [
    TimedTemperature(time: Date(timeIntervalSinceNow: 0), temperature: 21.1),
    TimedTemperature(time: Date(timeIntervalSinceNow: 3600), temperature: 23.6),
    TimedTemperature(time: Date(timeIntervalSinceNow: 7200), temperature: 24.2),
    TimedTemperature(time: Date(timeIntervalSinceNow: 10800), temperature: 23.7),
])

extension GeoWeather {

    static let sampleData = [
        GeoWeather(id: 0, geocoding: geoMoscow, weather: weatherMoscow),
        GeoWeather(id: 1, geocoding: geoPskov, weather: weatherPskov)
    ]
}

#endif
