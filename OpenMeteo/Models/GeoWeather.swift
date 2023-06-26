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
let weatherMoscow = Weather(
    current: HourForecast(time: Date(timeIntervalSinceNow: 0), temperature: 24.3),
    forecastByHour: [
        HourForecast(time: Date(timeIntervalSinceNow: -3600), temperature: 23.7),
        HourForecast(time: Date(timeIntervalSinceNow: 0), temperature: 24.3),
        HourForecast(time: Date(timeIntervalSinceNow: 3600), temperature: 25.2),
        HourForecast(time: Date(timeIntervalSinceNow: 7200), temperature: 26.1),
        HourForecast(time: Date(timeIntervalSinceNow: 10800), temperature: 25.8),
    ])

let geoPskov = Geocoding(id: 504341, name: "Pskov", latitude: 57.8136, longitude: 28.3496, country: "Russia")
let weatherPskov = Weather(
    current: HourForecast(time: Date(timeIntervalSinceNow: 0), temperature: 22.5),
    forecastByHour: [
        HourForecast(time: Date(timeIntervalSinceNow: -3600), temperature: 21.1),
        HourForecast(time: Date(timeIntervalSinceNow: 0), temperature: 22.5),
        HourForecast(time: Date(timeIntervalSinceNow: 3600), temperature: 23.6),
        HourForecast(time: Date(timeIntervalSinceNow: 7200), temperature: 24.2),
        HourForecast(time: Date(timeIntervalSinceNow: 10800), temperature: 23.7),
])

extension GeoWeather {

    static let sampleData = [
        GeoWeather(id: 0, geocoding: geoMoscow, weather: weatherMoscow),
        GeoWeather(id: 1, geocoding: geoPskov, weather: realWeatherPskov)
    ]
    
    static let realSampleData = [
        GeoWeather(id: 0, geocoding: geoMoscow, weather: weatherMoscow),
        GeoWeather(id: 1, geocoding: geoPskov, weather: realWeatherPskov)
    ]
}

let realWeatherPskov: Weather = {
    return try! JSONDecoder().decode(WeatherJSON.self, from: weatherJSONData).weather
}()

let weatherJSONData = """
{"latitude":57.81321,"longitude":28.357056,"generationtime_ms":0.30100345611572266,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":52.0,"current_weather":{"temperature":21.0,"windspeed":7.6,"winddirection":352.0,"weathercode":1,"is_day":1,"time":"2023-06-25T17:00"},"hourly_units":{"time":"iso8601","temperature_2m":"°C"},"hourly":{"time":["2023-06-25T00:00","2023-06-25T01:00","2023-06-25T02:00","2023-06-25T03:00","2023-06-25T04:00","2023-06-25T05:00","2023-06-25T06:00","2023-06-25T07:00","2023-06-25T08:00","2023-06-25T09:00","2023-06-25T10:00","2023-06-25T11:00","2023-06-25T12:00","2023-06-25T13:00","2023-06-25T14:00","2023-06-25T15:00","2023-06-25T16:00","2023-06-25T17:00","2023-06-25T18:00","2023-06-25T19:00","2023-06-25T20:00","2023-06-25T21:00","2023-06-25T22:00","2023-06-25T23:00","2023-06-26T00:00","2023-06-26T01:00","2023-06-26T02:00","2023-06-26T03:00","2023-06-26T04:00","2023-06-26T05:00","2023-06-26T06:00","2023-06-26T07:00","2023-06-26T08:00","2023-06-26T09:00","2023-06-26T10:00","2023-06-26T11:00","2023-06-26T12:00","2023-06-26T13:00","2023-06-26T14:00","2023-06-26T15:00","2023-06-26T16:00","2023-06-26T17:00","2023-06-26T18:00","2023-06-26T19:00","2023-06-26T20:00","2023-06-26T21:00","2023-06-26T22:00","2023-06-26T23:00","2023-06-27T00:00","2023-06-27T01:00","2023-06-27T02:00","2023-06-27T03:00","2023-06-27T04:00","2023-06-27T05:00","2023-06-27T06:00","2023-06-27T07:00","2023-06-27T08:00","2023-06-27T09:00","2023-06-27T10:00","2023-06-27T11:00","2023-06-27T12:00","2023-06-27T13:00","2023-06-27T14:00","2023-06-27T15:00","2023-06-27T16:00","2023-06-27T17:00","2023-06-27T18:00","2023-06-27T19:00","2023-06-27T20:00","2023-06-27T21:00","2023-06-27T22:00","2023-06-27T23:00","2023-06-28T00:00","2023-06-28T01:00","2023-06-28T02:00","2023-06-28T03:00","2023-06-28T04:00","2023-06-28T05:00","2023-06-28T06:00","2023-06-28T07:00","2023-06-28T08:00","2023-06-28T09:00","2023-06-28T10:00","2023-06-28T11:00","2023-06-28T12:00","2023-06-28T13:00","2023-06-28T14:00","2023-06-28T15:00","2023-06-28T16:00","2023-06-28T17:00","2023-06-28T18:00","2023-06-28T19:00","2023-06-28T20:00","2023-06-28T21:00","2023-06-28T22:00","2023-06-28T23:00","2023-06-29T00:00","2023-06-29T01:00","2023-06-29T02:00","2023-06-29T03:00","2023-06-29T04:00","2023-06-29T05:00","2023-06-29T06:00","2023-06-29T07:00","2023-06-29T08:00","2023-06-29T09:00","2023-06-29T10:00","2023-06-29T11:00","2023-06-29T12:00","2023-06-29T13:00","2023-06-29T14:00","2023-06-29T15:00","2023-06-29T16:00","2023-06-29T17:00","2023-06-29T18:00","2023-06-29T19:00","2023-06-29T20:00","2023-06-29T21:00","2023-06-29T22:00","2023-06-29T23:00","2023-06-30T00:00","2023-06-30T01:00","2023-06-30T02:00","2023-06-30T03:00","2023-06-30T04:00","2023-06-30T05:00","2023-06-30T06:00","2023-06-30T07:00","2023-06-30T08:00","2023-06-30T09:00","2023-06-30T10:00","2023-06-30T11:00","2023-06-30T12:00","2023-06-30T13:00","2023-06-30T14:00","2023-06-30T15:00","2023-06-30T16:00","2023-06-30T17:00","2023-06-30T18:00","2023-06-30T19:00","2023-06-30T20:00","2023-06-30T21:00","2023-06-30T22:00","2023-06-30T23:00","2023-07-01T00:00","2023-07-01T01:00","2023-07-01T02:00","2023-07-01T03:00","2023-07-01T04:00","2023-07-01T05:00","2023-07-01T06:00","2023-07-01T07:00","2023-07-01T08:00","2023-07-01T09:00","2023-07-01T10:00","2023-07-01T11:00","2023-07-01T12:00","2023-07-01T13:00","2023-07-01T14:00","2023-07-01T15:00","2023-07-01T16:00","2023-07-01T17:00","2023-07-01T18:00","2023-07-01T19:00","2023-07-01T20:00","2023-07-01T21:00","2023-07-01T22:00","2023-07-01T23:00"],"temperature_2m":[18.6,17.8,17.2,16.6,16.8,17.3,17.9,19.1,20.3,20.6,21.4,21.7,22.0,22.3,22.4,21.8,21.5,21.0,20.5,19.7,19.1,18.0,17.2,16.4,15.8,15.2,15.1,15.9,17.1,18.8,20.6,21.6,22.5,22.8,23.5,23.6,20.6,18.1,19.7,20.1,20.8,20.9,20.5,20.1,20.0,19.2,18.4,17.8,17.3,16.7,16.3,16.4,17.1,18.3,19.9,21.3,22.5,23.0,23.5,24.2,25.1,25.6,25.5,23.7,22.6,19.9,19.5,19.3,18.7,18.3,17.7,17.3,17.1,16.7,13.0,13.9,15.6,18.6,21.0,22.9,24.3,24.0,25.1,25.3,26.0,26.0,25.7,24.7,23.5,21.7,20.3,18.8,17.3,16.2,15.4,15.0,14.9,14.9,15.3,16.2,17.9,20.1,22.0,23.3,24.3,25.1,25.7,26.0,26.2,26.2,25.9,25.4,24.4,23.1,21.7,20.0,18.2,16.8,16.0,15.7,15.5,15.5,15.8,16.5,17.9,19.7,21.3,22.4,23.4,24.0,24.3,24.4,24.4,24.2,23.3,22.5,21.6,20.8,19.7,18.4,16.9,15.6,14.7,13.9,13.4,13.2,13.3,13.9,15.3,17.3,19.1,20.7,22.1,23.3,24.2,24.7,25.1,25.3,25.4,25.2,24.5,23.4,22.2,20.7,19.1,17.7,16.4,15.2]}}
""".data(using: .utf8)!


#endif
