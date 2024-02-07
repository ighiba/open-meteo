//
//  GeoWeather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

final class GeoWeather: Identifiable {
    var id: Int
    var geocoding: Geocoding
    var weather: Weather?
    
    init(geocoding: Geocoding) {
        self.id = geocoding.id
        self.geocoding = geocoding
        self.weather = nil
    }
    
    init(geocoding: Geocoding, weather: Weather) {
        self.id = geocoding.id
        self.geocoding = geocoding
        self.weather = weather
    }
}

#if DEBUG

private let geoMoscow = Geocoding(
    id: 524901,
    name: "Москва",
    latitude: 55.75222,
    longitude: 37.61556,
    country: "Russia",
    adminLocation: "Moskovskaya. obl"
)

private let geoPskov = Geocoding(
    id: 504341,
    name: "Псков",
    latitude: 57.8136,
    longitude: 28.3496,
    country: "Russia",
    adminLocation: "Pskovskaya. obl"

)

private let geoStPetersburg = Geocoding(
    id: 504342,
    name: "Санкт-Петербург",
    latitude: 59.93863,
    longitude: 30.31413,
    country: "Russia",
    adminLocation: "Leningradskaya. obl"
)


extension GeoWeather {
    static let sampleData = [
        GeoWeather(geocoding: geoMoscow, weather: realWeatherMoscow),
        GeoWeather(geocoding: geoPskov, weather: realWeatherPskov),
        GeoWeather(geocoding: geoStPetersburg),
    ]
}

private let realWeatherPskov: Weather = {
    return try! JSONDecoder().decode(WeatherJSON.self, from: weatherJSONDataPskov).result
}()

private let realWeatherMoscow: Weather = {
    return try! JSONDecoder().decode(WeatherJSON.self, from: weatherJSONDataMoscow).result
}()

private let weatherJSONDataPskov = """
{"latitude":57.81321,"longitude":28.357056,"generationtime_ms":0.9820461273193359,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":52.0,"current_weather":{"temperature":15.8,"windspeed":15.8,"winddirection":230.0,"weathercode":1,"is_day":0,"time":"2023-07-02T00:00"},"hourly_units":{"time":"iso8601","temperature_2m":"°C","relativehumidity_2m":"%","apparent_temperature":"°C","precipitation_probability":"%","weathercode":"wmo code","windspeed_10m":"km/h","winddirection_10m":"°","is_day":""},"hourly":{"time":["2023-07-02T00:00","2023-07-02T01:00","2023-07-02T02:00","2023-07-02T03:00","2023-07-02T04:00","2023-07-02T05:00","2023-07-02T06:00","2023-07-02T07:00","2023-07-02T08:00","2023-07-02T09:00","2023-07-02T10:00","2023-07-02T11:00","2023-07-02T12:00","2023-07-02T13:00","2023-07-02T14:00","2023-07-02T15:00","2023-07-02T16:00","2023-07-02T17:00","2023-07-02T18:00","2023-07-02T19:00","2023-07-02T20:00","2023-07-02T21:00","2023-07-02T22:00","2023-07-02T23:00","2023-07-03T00:00","2023-07-03T01:00","2023-07-03T02:00","2023-07-03T03:00","2023-07-03T04:00","2023-07-03T05:00","2023-07-03T06:00","2023-07-03T07:00","2023-07-03T08:00","2023-07-03T09:00","2023-07-03T10:00","2023-07-03T11:00","2023-07-03T12:00","2023-07-03T13:00","2023-07-03T14:00","2023-07-03T15:00","2023-07-03T16:00","2023-07-03T17:00","2023-07-03T18:00","2023-07-03T19:00","2023-07-03T20:00","2023-07-03T21:00","2023-07-03T22:00","2023-07-03T23:00","2023-07-04T00:00","2023-07-04T01:00","2023-07-04T02:00","2023-07-04T03:00","2023-07-04T04:00","2023-07-04T05:00","2023-07-04T06:00","2023-07-04T07:00","2023-07-04T08:00","2023-07-04T09:00","2023-07-04T10:00","2023-07-04T11:00","2023-07-04T12:00","2023-07-04T13:00","2023-07-04T14:00","2023-07-04T15:00","2023-07-04T16:00","2023-07-04T17:00","2023-07-04T18:00","2023-07-04T19:00","2023-07-04T20:00","2023-07-04T21:00","2023-07-04T22:00","2023-07-04T23:00","2023-07-05T00:00","2023-07-05T01:00","2023-07-05T02:00","2023-07-05T03:00","2023-07-05T04:00","2023-07-05T05:00","2023-07-05T06:00","2023-07-05T07:00","2023-07-05T08:00","2023-07-05T09:00","2023-07-05T10:00","2023-07-05T11:00","2023-07-05T12:00","2023-07-05T13:00","2023-07-05T14:00","2023-07-05T15:00","2023-07-05T16:00","2023-07-05T17:00","2023-07-05T18:00","2023-07-05T19:00","2023-07-05T20:00","2023-07-05T21:00","2023-07-05T22:00","2023-07-05T23:00","2023-07-06T00:00","2023-07-06T01:00","2023-07-06T02:00","2023-07-06T03:00","2023-07-06T04:00","2023-07-06T05:00","2023-07-06T06:00","2023-07-06T07:00","2023-07-06T08:00","2023-07-06T09:00","2023-07-06T10:00","2023-07-06T11:00","2023-07-06T12:00","2023-07-06T13:00","2023-07-06T14:00","2023-07-06T15:00","2023-07-06T16:00","2023-07-06T17:00","2023-07-06T18:00","2023-07-06T19:00","2023-07-06T20:00","2023-07-06T21:00","2023-07-06T22:00","2023-07-06T23:00","2023-07-07T00:00","2023-07-07T01:00","2023-07-07T02:00","2023-07-07T03:00","2023-07-07T04:00","2023-07-07T05:00","2023-07-07T06:00","2023-07-07T07:00","2023-07-07T08:00","2023-07-07T09:00","2023-07-07T10:00","2023-07-07T11:00","2023-07-07T12:00","2023-07-07T13:00","2023-07-07T14:00","2023-07-07T15:00","2023-07-07T16:00","2023-07-07T17:00","2023-07-07T18:00","2023-07-07T19:00","2023-07-07T20:00","2023-07-07T21:00","2023-07-07T22:00","2023-07-07T23:00","2023-07-08T00:00","2023-07-08T01:00","2023-07-08T02:00","2023-07-08T03:00","2023-07-08T04:00","2023-07-08T05:00","2023-07-08T06:00","2023-07-08T07:00","2023-07-08T08:00","2023-07-08T09:00","2023-07-08T10:00","2023-07-08T11:00","2023-07-08T12:00","2023-07-08T13:00","2023-07-08T14:00","2023-07-08T15:00","2023-07-08T16:00","2023-07-08T17:00","2023-07-08T18:00","2023-07-08T19:00","2023-07-08T20:00","2023-07-08T21:00","2023-07-08T22:00","2023-07-08T23:00"],"temperature_2m":[15.8,15.5,15.4,15.5,16.2,17.7,18.9,20.2,21.2,21.4,20.5,19.7,19.2,20.7,21.1,20.2,18.0,16.9,16.8,16.9,16.6,16.1,15.9,15.9,15.2,14.5,14.2,14.3,14.7,15.5,16.2,17.0,17.9,18.1,17.4,17.8,18.1,20.0,19.6,19.9,19.0,18.4,17.9,17.3,17.0,16.4,16.2,15.7,14.9,14.5,14.3,14.5,15.6,17.1,18.6,19.0,19.1,20.2,20.6,21.0,21.5,22.5,22.6,22.4,21.7,20.9,19.5,17.2,15.7,15.0,14.6,14.1,13.4,13.2,13.1,13.6,15.2,17.3,19.3,21.0,22.6,23.9,24.8,25.5,26.0,26.5,26.8,26.5,25.3,23.5,21.7,20.3,18.9,17.8,17.1,16.7,16.5,16.6,16.9,17.8,19.7,22.1,24.3,26.1,27.5,27.9,26.4,23.9,21.7,20.3,19.3,18.4,17.7,17.2,16.9,17.4,16.2,15.2,14.1,13.1,12.5,12.1,12.1,12.8,14.8,17.6,19.9,21.3,22.1,22.9,23.7,24.4,24.9,25.1,25.1,24.6,23.4,21.8,20.3,19.1,18.1,17.2,16.3,15.5,15.0,14.7,14.7,15.3,16.9,19.0,20.8,21.9,22.6,23.2,23.8,24.3,24.5,24.5,24.1,23.5,22.5,21.3,20.0,18.6,17.3,16.2,15.4,14.9],"relativehumidity_2m":[71,71,70,68,65,61,56,51,48,44,53,60,62,57,56,63,80,88,90,91,91,90,91,89,88,87,86,86,82,77,73,70,63,62,65,63,60,53,59,54,58,61,60,58,58,64,66,68,69,68,70,69,65,60,54,54,50,46,45,45,42,37,36,37,39,44,49,57,62,63,62,63,66,67,69,68,64,57,51,46,42,38,35,33,32,30,29,30,35,43,49,52,54,56,59,61,63,64,65,64,61,56,52,47,43,43,52,66,77,83,87,89,90,90,90,78,78,78,80,82,84,86,88,86,79,69,60,54,48,44,40,37,35,34,34,36,43,52,60,63,63,66,73,81,88,92,93,91,84,73,64,58,54,50,46,42,40,39,39,41,44,48,54,62,71,79,85,90],"apparent_temperature":[13.7,13.5,13.3,13.6,14.3,16.0,17.1,18.1,19.1,18.8,18.2,18.0,17.7,19.1,19.3,18.4,17.0,16.1,15.9,16.4,16.2,15.4,15.2,15.1,13.7,12.7,12.3,12.5,12.3,13.1,13.7,14.4,14.9,15.1,14.1,14.8,15.0,16.9,16.8,17.2,15.6,15.2,14.8,14.0,13.7,14.1,13.8,13.6,12.5,11.9,11.7,11.8,13.0,14.3,15.8,16.3,15.7,17.3,17.9,18.4,19.0,19.3,19.1,19.2,18.8,18.9,17.8,15.7,14.0,13.1,12.3,11.9,11.3,11.1,11.1,11.7,13.2,15.2,16.9,18.5,20.6,22.2,23.2,23.6,24.0,24.6,24.9,25.0,24.4,23.0,21.1,19.4,17.8,16.6,15.9,15.4,15.2,15.3,15.8,16.9,18.9,21.5,23.8,25.5,27.3,28.1,27.6,25.4,22.6,21.0,19.9,19.0,18.4,18.0,17.8,17.9,16.2,14.8,13.6,12.6,11.9,11.7,11.8,12.6,14.8,17.8,20.0,21.1,21.5,22.0,22.8,23.4,23.6,23.5,23.5,23.2,22.5,21.5,20.4,19.1,17.6,16.4,15.8,15.4,15.2,15.1,15.2,15.8,17.4,19.3,20.8,21.6,22.2,22.9,23.4,23.6,23.4,22.9,22.3,22.0,21.2,20.2,19.3,18.2,17.1,16.2,15.6,15.3],"precipitation_probability":[0,0,0,0,0,0,0,3,7,10,24,38,52,54,56,58,71,84,97,89,82,74,51,29,6,8,11,13,14,15,16,38,59,81,83,85,87,91,96,100,91,83,74,51,29,6,7,9,10,8,5,3,3,3,3,27,50,74,75,76,77,79,82,84,74,65,55,38,20,3,4,5,6,4,2,0,0,0,0,3,7,10,10,10,10,10,10,10,7,3,0,2,4,6,8,11,13,13,13,13,16,20,23,24,25,26,24,21,19,17,15,13,12,11,10,15,21,26,27,28,29,31,33,35,33,31,29,29,29,29,26,22,19,17,15,13,11,8,6,7,9,10,9,7,6,4,2,0,0,0,0,3,7,10,11,12,13,14,15,16,14,12,10,9,7,6,6,6],"weathercode":[1,0,2,0,0,0,1,1,2,2,3,3,3,2,3,3,53,53,53,51,53,2,3,55,0,1,1,1,2,2,3,2,3,3,3,3,3,2,1,1,2,2,1,2,1,1,0,0,0,0,0,0,0,0,2,1,1,2,2,2,2,1,1,1,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,2,2,2,61,61,61,80,80,80,3,3,3,1,1,1,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,0,0,0,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3],"windspeed_10m":[15.8,14.8,14.4,12.2,12.2,11.9,12.2,14.0,15.5,18.4,17.3,15.5,14.0,15.1,16.6,19.1,17.3,16.9,17.6,15.8,14.4,14.8,14.4,14.8,17.3,16.9,16.6,16.2,19.4,19.4,19.8,20.9,22.0,22.0,23.8,22.0,21.6,21.6,22.3,19.4,24.5,23.0,20.9,21.2,20.5,15.1,16.2,13.7,15.5,15.5,15.5,16.6,15.8,17.6,17.6,17.6,20.8,20.7,19.2,19.2,17.0,17.8,17.9,16.6,14.7,10.8,9.2,7.8,8.9,9.8,11.3,10.1,9.7,9.3,9.3,9.4,10.7,12.6,14.4,15.3,15.8,15.9,16.0,15.7,14.6,12.0,9.0,6.2,3.9,3.9,5.4,6.2,6.5,6.6,6.9,7.4,8.1,8.0,7.9,8.1,9.4,10.9,11.9,12.3,12.6,11.4,6.4,7.3,12.4,13.7,13.0,11.5,9.4,7.2,5.5,4.0,5.1,5.4,5.1,4.0,3.2,2.5,2.4,2.3,2.6,2.7,3.3,4.3,5.4,6.2,6.6,7.0,7.2,7.3,7.2,6.9,6.1,4.7,4.0,4.3,5.8,7.0,6.6,5.8,5.1,4.8,4.8,5.1,5.8,7.1,8.4,9.0,9.5,10.2,11.0,11.9,12.6,12.1,10.8,9.5,8.2,6.8,5.6,5.2,4.9,5.0,4.8,4.5],"winddirection_10m":[230,224,220,215,215,218,207,208,213,197,191,187,176,172,181,185,173,166,187,198,198,201,196,214,208,204,201,196,202,205,213,194,202,204,214,196,203,212,209,213,208,213,209,208,212,196,192,203,195,197,194,190,198,200,213,213,233,235,240,244,249,249,245,243,242,233,225,214,212,208,211,207,207,208,208,212,222,233,238,240,243,245,247,250,254,261,272,291,326,22,53,69,87,103,118,137,148,153,156,159,157,153,155,165,180,193,223,303,324,325,321,316,313,307,302,275,274,278,278,275,270,262,243,231,236,247,257,265,270,277,283,291,297,303,307,313,320,328,333,318,300,291,292,300,309,312,312,315,330,345,350,344,335,328,328,331,333,333,334,335,337,342,345,344,343,339,333,331],"is_day":[0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0]},"daily_units":{"time":"iso8601","weathercode":"wmo code","temperature_2m_max":"°C","temperature_2m_min":"°C","sunrise":"iso8601","sunset":"iso8601","precipitation_sum":"mm","precipitation_probability_max":"%"},"daily":{"time":["2023-07-02","2023-07-03","2023-07-04","2023-07-05","2023-07-06","2023-07-07","2023-07-08"],"weathercode":[55,3,3,2,80,3,3],"temperature_2m_max":[21.4,20.0,22.6,26.8,27.9,25.1,24.5],"temperature_2m_min":[15.4,14.2,14.1,13.1,13.1,12.1,14.7],"sunrise":["2023-07-02T01:11","2023-07-03T01:12","2023-07-04T01:13","2023-07-05T01:14","2023-07-06T01:15","2023-07-07T01:16","2023-07-08T01:18"],"sunset":["2023-07-02T19:09","2023-07-03T19:09","2023-07-04T19:08","2023-07-05T19:07","2023-07-06T19:06","2023-07-07T19:06","2023-07-08T19:05"],"precipitation_sum":[4.10,0.00,0.30,0.00,3.00,0.00,0.00],"precipitation_probability_max":[97,100,84,11,28,35,16]}}
""".data(using: .utf8)!

let weatherJSONDataMoscow = """
{"latitude":55.75,"longitude":37.625,"generationtime_ms":0.9859800338745117,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":130.0,"current_weather":{"temperature":16.9,"windspeed":7.6,"winddirection":265.0,"weathercode":1,"is_day":0,"time":"2023-07-02T00:00"},"hourly_units":{"time":"iso8601","temperature_2m":"°C","relativehumidity_2m":"%","apparent_temperature":"°C","precipitation_probability":"%","weathercode":"wmo code","windspeed_10m":"km/h","winddirection_10m":"°","is_day":""},"hourly":{"time":["2023-07-02T00:00","2023-07-02T01:00","2023-07-02T02:00","2023-07-02T03:00","2023-07-02T04:00","2023-07-02T05:00","2023-07-02T06:00","2023-07-02T07:00","2023-07-02T08:00","2023-07-02T09:00","2023-07-02T10:00","2023-07-02T11:00","2023-07-02T12:00","2023-07-02T13:00","2023-07-02T14:00","2023-07-02T15:00","2023-07-02T16:00","2023-07-02T17:00","2023-07-02T18:00","2023-07-02T19:00","2023-07-02T20:00","2023-07-02T21:00","2023-07-02T22:00","2023-07-02T23:00","2023-07-03T00:00","2023-07-03T01:00","2023-07-03T02:00","2023-07-03T03:00","2023-07-03T04:00","2023-07-03T05:00","2023-07-03T06:00","2023-07-03T07:00","2023-07-03T08:00","2023-07-03T09:00","2023-07-03T10:00","2023-07-03T11:00","2023-07-03T12:00","2023-07-03T13:00","2023-07-03T14:00","2023-07-03T15:00","2023-07-03T16:00","2023-07-03T17:00","2023-07-03T18:00","2023-07-03T19:00","2023-07-03T20:00","2023-07-03T21:00","2023-07-03T22:00","2023-07-03T23:00","2023-07-04T00:00","2023-07-04T01:00","2023-07-04T02:00","2023-07-04T03:00","2023-07-04T04:00","2023-07-04T05:00","2023-07-04T06:00","2023-07-04T07:00","2023-07-04T08:00","2023-07-04T09:00","2023-07-04T10:00","2023-07-04T11:00","2023-07-04T12:00","2023-07-04T13:00","2023-07-04T14:00","2023-07-04T15:00","2023-07-04T16:00","2023-07-04T17:00","2023-07-04T18:00","2023-07-04T19:00","2023-07-04T20:00","2023-07-04T21:00","2023-07-04T22:00","2023-07-04T23:00","2023-07-05T00:00","2023-07-05T01:00","2023-07-05T02:00","2023-07-05T03:00","2023-07-05T04:00","2023-07-05T05:00","2023-07-05T06:00","2023-07-05T07:00","2023-07-05T08:00","2023-07-05T09:00","2023-07-05T10:00","2023-07-05T11:00","2023-07-05T12:00","2023-07-05T13:00","2023-07-05T14:00","2023-07-05T15:00","2023-07-05T16:00","2023-07-05T17:00","2023-07-05T18:00","2023-07-05T19:00","2023-07-05T20:00","2023-07-05T21:00","2023-07-05T22:00","2023-07-05T23:00","2023-07-06T00:00","2023-07-06T01:00","2023-07-06T02:00","2023-07-06T03:00","2023-07-06T04:00","2023-07-06T05:00","2023-07-06T06:00","2023-07-06T07:00","2023-07-06T08:00","2023-07-06T09:00","2023-07-06T10:00","2023-07-06T11:00","2023-07-06T12:00","2023-07-06T13:00","2023-07-06T14:00","2023-07-06T15:00","2023-07-06T16:00","2023-07-06T17:00","2023-07-06T18:00","2023-07-06T19:00","2023-07-06T20:00","2023-07-06T21:00","2023-07-06T22:00","2023-07-06T23:00","2023-07-07T00:00","2023-07-07T01:00","2023-07-07T02:00","2023-07-07T03:00","2023-07-07T04:00","2023-07-07T05:00","2023-07-07T06:00","2023-07-07T07:00","2023-07-07T08:00","2023-07-07T09:00","2023-07-07T10:00","2023-07-07T11:00","2023-07-07T12:00","2023-07-07T13:00","2023-07-07T14:00","2023-07-07T15:00","2023-07-07T16:00","2023-07-07T17:00","2023-07-07T18:00","2023-07-07T19:00","2023-07-07T20:00","2023-07-07T21:00","2023-07-07T22:00","2023-07-07T23:00","2023-07-08T00:00","2023-07-08T01:00","2023-07-08T02:00","2023-07-08T03:00","2023-07-08T04:00","2023-07-08T05:00","2023-07-08T06:00","2023-07-08T07:00","2023-07-08T08:00","2023-07-08T09:00","2023-07-08T10:00","2023-07-08T11:00","2023-07-08T12:00","2023-07-08T13:00","2023-07-08T14:00","2023-07-08T15:00","2023-07-08T16:00","2023-07-08T17:00","2023-07-08T18:00","2023-07-08T19:00","2023-07-08T20:00","2023-07-08T21:00","2023-07-08T22:00","2023-07-08T23:00"],"temperature_2m":[16.9,16.4,16.3,16.6,17.6,18.5,19.3,20.3,21.3,22.1,22.4,23.1,23.5,23.5,23.3,23.2,22.7,22.0,20.9,19.7,18.9,18.5,18.1,18.1,17.7,16.5,16.8,17.5,17.9,18.7,19.6,20.2,21.7,22.4,23.0,23.2,23.3,23.7,23.6,23.4,22.9,22.2,20.7,19.1,18.1,17.4,16.9,16.5,16.5,16.4,16.2,16.5,17.3,18.7,20.7,22.3,23.3,23.8,24.1,24.8,25.2,25.3,25.7,25.5,25.0,24.0,22.5,21.3,20.7,20.0,19.5,19.2,18.7,18.4,18.1,18.5,19.8,21.6,23.3,24.6,25.7,26.6,27.1,27.4,27.5,27.6,27.6,27.4,26.7,25.7,24.7,23.7,22.6,21.5,20.5,19.5,18.9,18.6,18.7,19.3,20.9,23.1,25.1,26.6,28.0,29.0,29.4,29.4,29.3,29.5,29.6,29.4,28.5,27.2,26.3,26.0,24.9,23.8,22.9,22.0,21.4,21.0,20.9,21.3,22.6,24.4,26.2,27.8,29.3,30.5,31.2,31.6,31.8,31.9,31.8,31.3,30.4,29.2,27.9,26.6,25.2,24.2,23.7,23.5,23.3,22.8,22.2,22.3,23.4,25.1,26.8,28.3,29.9,31.2,32.3,33.1,33.6,33.7,33.4,32.7,31.5,30.0,28.4,26.8,25.1,23.7,22.5,21.6],"relativehumidity_2m":[87,91,92,89,82,75,69,64,51,43,41,41,40,38,40,40,41,44,51,56,60,62,63,62,65,88,90,89,85,79,70,61,50,49,44,44,42,37,36,35,35,37,43,51,56,58,60,61,62,63,66,67,64,58,49,40,35,32,32,31,31,32,31,33,35,40,47,52,55,59,62,64,66,68,70,69,64,56,49,42,36,31,29,29,29,29,30,31,34,37,40,42,43,44,46,49,51,52,51,50,47,44,41,39,37,36,38,41,43,41,38,37,40,45,49,52,55,57,58,58,58,58,58,56,52,48,43,38,34,30,28,27,27,27,27,28,31,35,39,43,46,49,49,49,49,52,55,56,53,48,43,39,35,31,28,25,23,23,25,28,31,35,41,50,61,70,76,81],"apparent_temperature":[17.4,16.9,16.8,16.4,17.7,18.1,18.8,19.7,19.8,19.8,19.8,21.0,21.5,21.2,21.2,21.1,21.1,21.0,20.5,19.3,18.5,18.2,17.6,17.4,17.1,16.7,17.3,17.9,17.6,18.6,18.6,18.8,20.4,21.6,21.8,21.6,21.4,21.3,20.9,20.6,20.4,20.0,19.3,18.0,17.2,16.4,15.7,15.3,15.4,15.2,15.0,15.6,16.3,17.7,19.4,20.9,21.4,21.2,21.1,22.1,22.4,23.0,23.1,23.5,23.1,22.8,21.9,20.7,20.3,19.9,19.4,19.2,18.6,18.4,18.4,18.9,20.3,22.0,23.4,24.1,25.0,25.5,25.7,25.7,25.5,25.6,25.8,25.8,25.6,25.2,24.5,23.5,22.2,21.1,20.1,19.0,18.3,17.9,17.9,18.6,20.3,22.5,24.6,26.5,28.4,29.5,30.0,29.9,29.4,29.4,29.5,29.3,28.7,27.7,26.9,27.1,25.9,24.7,23.5,22.2,21.4,21.0,20.9,21.3,22.4,24.2,25.8,27.2,29.1,30.5,31.2,31.6,31.6,31.3,30.7,30.4,30.0,29.2,28.2,26.9,25.5,24.4,23.9,23.9,23.7,23.2,22.7,22.8,23.9,25.5,27.1,28.5,29.8,31.0,32.1,32.7,32.7,32.5,32.5,32.3,31.5,30.1,28.7,27.8,26.8,25.6,24.6,23.8],"precipitation_probability":[19,14,8,3,2,1,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,8,11,13,19,26,32,30,28,26,25,24,23,17,12,6,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,5,4,3,2,1,0,1,2,3,2,1,0,1,2,3,3,3,3,5,8,10,9,7,6,7,9,10,8,5,3,2,1,0,0,0,0,2,4,6,5,4,3,6,10,13,13,13,13,16,20,23,20,16,13,11,8,6,12,17,23,23,23,23,23,23,23,24,25,26,23,19,16,17,18,19,23,28,32,32,32,32,28,23,19,20,22,23,25,27,29,27,25,23,28,34,39,39,39,39,30,22,13,15,17,19,19,19],"weathercode":[1,2,2,3,2,2,2,3,3,3,3,2,3,3,2,3,3,2,3,3,3,3,3,3,3,80,80,3,3,2,2,2,1,1,2,2,2,2,2,2,1,0,0,1,1,1,0,2,2,2,2,2,3,1,0,0,3,3,3,2,2,2,1,2,1,2,2,1,3,2,2,2,3,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,3,3,3,3,3,3,2,2,2,3,3,3,1,1,1,1,1,1,3,3,3,1,1,1,1,1,1,1,1,1,1,1,1,3,3,3,2,2,2,3,3,3,2,2,2,2,2,2,2,2,2,1,1,1,2,2,2,2,2,2,2,2,2,2,2],"windspeed_10m":[7.6,7.6,8.0,11.6,9.1,11.7,10.8,10.9,13.4,13.8,14.8,13.7,13.7,13.0,11.9,11.9,8.7,5.2,3.3,4.0,4.7,4.3,5.6,6.1,6.7,8.4,8.7,10.3,13.9,11.4,16.0,15.0,15.5,15.5,16.9,16.4,16.2,15.2,14.7,13.8,11.4,9.2,5.8,5.1,4.9,5.0,6.1,6.4,6.4,7.1,7.5,6.3,7.6,7.0,7.8,10.6,13.6,14.9,14.0,13.5,13.3,10.7,12.9,10.2,10.4,7.7,5.6,5.9,5.5,4.7,4.8,4.8,5.2,4.7,3.4,2.6,2.1,2.4,3.1,4.9,7.9,9.8,10.6,10.7,10.6,9.9,9.4,8.4,6.3,3.8,1.9,1.1,1.1,0.7,0.4,1.0,1.8,2.1,2.3,2.5,3.0,4.0,4.9,6.1,7.6,8.9,10.2,11.6,12.5,11.4,8.6,6.9,6.3,6.4,6.6,4.6,5.0,5.2,5.4,6.0,6.3,5.9,5.1,5.1,5.9,7.3,8.4,9.4,10.5,11.2,11.2,10.8,10.1,9.4,8.6,7.6,5.8,4.3,3.8,4.1,4.6,4.6,3.6,2.4,1.8,2.2,2.6,3.2,3.9,4.3,4.8,5.4,6.3,6.9,7.4,7.6,7.9,7.8,7.3,6.3,5.1,5.6,6.6,5.7,5.6,6.5,6.5,5.7],"winddirection_10m":[265,265,262,277,279,281,272,276,276,276,276,272,272,272,270,270,265,254,193,190,189,175,165,177,196,220,218,234,253,257,262,260,257,248,250,255,258,256,259,261,259,244,240,225,216,210,208,207,207,221,235,239,251,249,248,252,253,250,252,254,251,237,247,238,236,217,195,191,191,203,207,228,236,238,238,236,239,243,249,253,254,253,252,250,252,260,268,277,283,287,292,288,270,270,360,45,53,59,72,90,104,117,126,140,149,159,172,185,192,191,182,171,156,142,131,141,150,155,160,163,167,169,172,172,169,169,170,173,176,178,178,180,180,182,182,183,173,156,131,128,135,141,135,117,90,90,106,117,124,132,138,143,149,152,157,161,164,167,171,167,141,105,81,55,15,357,3,18],"is_day":[0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0]},"daily_units":{"time":"iso8601","weathercode":"wmo code","temperature_2m_max":"°C","temperature_2m_min":"°C","sunrise":"iso8601","sunset":"iso8601","precipitation_sum":"mm","precipitation_probability_max":"%"},"daily":{"time":["2023-07-02","2023-07-03","2023-07-04","2023-07-05","2023-07-06","2023-07-07","2023-07-08"],"weathercode":[3,80,3,3,3,3,3],"temperature_2m_max":[23.5,23.7,25.7,27.6,29.6,31.9,33.7],"temperature_2m_min":[16.3,16.5,16.2,18.1,18.6,20.9,21.6],"sunrise":["2023-07-02T00:50","2023-07-03T00:51","2023-07-04T00:52","2023-07-05T00:53","2023-07-06T00:54","2023-07-07T00:55","2023-07-08T00:56"],"sunset":["2023-07-02T18:16","2023-07-03T18:15","2023-07-04T18:15","2023-07-05T18:14","2023-07-06T18:13","2023-07-07T18:13","2023-07-08T18:12"],"precipitation_sum":[0.00,1.70,0.00,0.00,0.00,0.00,0.00],"precipitation_probability_max":[19,32,6,10,23,32,39]}}
""".data(using: .utf8)!

#endif
