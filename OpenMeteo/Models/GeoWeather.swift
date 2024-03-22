//
//  GeoWeather.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct GeoWeather: Identifiable {
    let id: Int
    var geocoding: Geocoding
    var weather: Weather
    
    init(geocoding: Geocoding, weather: Weather = Weather()) {
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
{"latitude":57.81321,"longitude":28.357056,"generationtime_ms":0.7060766220092773,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":51.0,"current_units":{"time":"iso8601","interval":"seconds","is_day":"","temperature_2m":"°C","apparent_temperature":"°C","relative_humidity_2m":"%","wind_speed_10m":"km/h","wind_direction_10m":"°","weather_code":"wmo code"},"current":{"time":"2024-03-04T18:15","interval":900,"is_day":0,"temperature_2m":0.2,"apparent_temperature":-3.2,"relative_humidity_2m":82,"wind_speed_10m":5.8,"wind_direction_10m":45,"weather_code":0},"hourly_units":{"time":"iso8601","is_day":"","temperature_2m":"°C","apparent_temperature":"°C","relativehumidity_2m":"%","precipitation_probability":"%","windspeed_10m":"km/h","winddirection_10m":"°","weathercode":"wmo code"},"hourly":{"time":["2024-03-04T00:00","2024-03-04T01:00","2024-03-04T02:00","2024-03-04T03:00","2024-03-04T04:00","2024-03-04T05:00","2024-03-04T06:00","2024-03-04T07:00","2024-03-04T08:00","2024-03-04T09:00","2024-03-04T10:00","2024-03-04T11:00","2024-03-04T12:00","2024-03-04T13:00","2024-03-04T14:00","2024-03-04T15:00","2024-03-04T16:00","2024-03-04T17:00","2024-03-04T18:00","2024-03-04T19:00","2024-03-04T20:00","2024-03-04T21:00","2024-03-04T22:00","2024-03-04T23:00","2024-03-05T00:00","2024-03-05T01:00","2024-03-05T02:00","2024-03-05T03:00","2024-03-05T04:00","2024-03-05T05:00","2024-03-05T06:00","2024-03-05T07:00","2024-03-05T08:00","2024-03-05T09:00","2024-03-05T10:00","2024-03-05T11:00","2024-03-05T12:00","2024-03-05T13:00","2024-03-05T14:00","2024-03-05T15:00","2024-03-05T16:00","2024-03-05T17:00","2024-03-05T18:00","2024-03-05T19:00","2024-03-05T20:00","2024-03-05T21:00","2024-03-05T22:00","2024-03-05T23:00","2024-03-06T00:00","2024-03-06T01:00","2024-03-06T02:00","2024-03-06T03:00","2024-03-06T04:00","2024-03-06T05:00","2024-03-06T06:00","2024-03-06T07:00","2024-03-06T08:00","2024-03-06T09:00","2024-03-06T10:00","2024-03-06T11:00","2024-03-06T12:00","2024-03-06T13:00","2024-03-06T14:00","2024-03-06T15:00","2024-03-06T16:00","2024-03-06T17:00","2024-03-06T18:00","2024-03-06T19:00","2024-03-06T20:00","2024-03-06T21:00","2024-03-06T22:00","2024-03-06T23:00","2024-03-07T00:00","2024-03-07T01:00","2024-03-07T02:00","2024-03-07T03:00","2024-03-07T04:00","2024-03-07T05:00","2024-03-07T06:00","2024-03-07T07:00","2024-03-07T08:00","2024-03-07T09:00","2024-03-07T10:00","2024-03-07T11:00","2024-03-07T12:00","2024-03-07T13:00","2024-03-07T14:00","2024-03-07T15:00","2024-03-07T16:00","2024-03-07T17:00","2024-03-07T18:00","2024-03-07T19:00","2024-03-07T20:00","2024-03-07T21:00","2024-03-07T22:00","2024-03-07T23:00","2024-03-08T00:00","2024-03-08T01:00","2024-03-08T02:00","2024-03-08T03:00","2024-03-08T04:00","2024-03-08T05:00","2024-03-08T06:00","2024-03-08T07:00","2024-03-08T08:00","2024-03-08T09:00","2024-03-08T10:00","2024-03-08T11:00","2024-03-08T12:00","2024-03-08T13:00","2024-03-08T14:00","2024-03-08T15:00","2024-03-08T16:00","2024-03-08T17:00","2024-03-08T18:00","2024-03-08T19:00","2024-03-08T20:00","2024-03-08T21:00","2024-03-08T22:00","2024-03-08T23:00","2024-03-09T00:00","2024-03-09T01:00","2024-03-09T02:00","2024-03-09T03:00","2024-03-09T04:00","2024-03-09T05:00","2024-03-09T06:00","2024-03-09T07:00","2024-03-09T08:00","2024-03-09T09:00","2024-03-09T10:00","2024-03-09T11:00","2024-03-09T12:00","2024-03-09T13:00","2024-03-09T14:00","2024-03-09T15:00","2024-03-09T16:00","2024-03-09T17:00","2024-03-09T18:00","2024-03-09T19:00","2024-03-09T20:00","2024-03-09T21:00","2024-03-09T22:00","2024-03-09T23:00","2024-03-10T00:00","2024-03-10T01:00","2024-03-10T02:00","2024-03-10T03:00","2024-03-10T04:00","2024-03-10T05:00","2024-03-10T06:00","2024-03-10T07:00","2024-03-10T08:00","2024-03-10T09:00","2024-03-10T10:00","2024-03-10T11:00","2024-03-10T12:00","2024-03-10T13:00","2024-03-10T14:00","2024-03-10T15:00","2024-03-10T16:00","2024-03-10T17:00","2024-03-10T18:00","2024-03-10T19:00","2024-03-10T20:00","2024-03-10T21:00","2024-03-10T22:00","2024-03-10T23:00","2024-03-11T00:00","2024-03-11T01:00","2024-03-11T02:00","2024-03-11T03:00","2024-03-11T04:00","2024-03-11T05:00","2024-03-11T06:00","2024-03-11T07:00","2024-03-11T08:00","2024-03-11T09:00","2024-03-11T10:00","2024-03-11T11:00","2024-03-11T12:00","2024-03-11T13:00","2024-03-11T14:00","2024-03-11T15:00","2024-03-11T16:00","2024-03-11T17:00","2024-03-11T18:00","2024-03-11T19:00","2024-03-11T20:00","2024-03-11T21:00","2024-03-11T22:00","2024-03-11T23:00","2024-03-12T00:00","2024-03-12T01:00","2024-03-12T02:00","2024-03-12T03:00","2024-03-12T04:00","2024-03-12T05:00","2024-03-12T06:00","2024-03-12T07:00","2024-03-12T08:00","2024-03-12T09:00","2024-03-12T10:00","2024-03-12T11:00","2024-03-12T12:00","2024-03-12T13:00","2024-03-12T14:00","2024-03-12T15:00","2024-03-12T16:00","2024-03-12T17:00","2024-03-12T18:00","2024-03-12T19:00","2024-03-12T20:00","2024-03-12T21:00","2024-03-12T22:00","2024-03-12T23:00","2024-03-13T00:00","2024-03-13T01:00","2024-03-13T02:00","2024-03-13T03:00","2024-03-13T04:00","2024-03-13T05:00","2024-03-13T06:00","2024-03-13T07:00","2024-03-13T08:00","2024-03-13T09:00","2024-03-13T10:00","2024-03-13T11:00","2024-03-13T12:00","2024-03-13T13:00","2024-03-13T14:00","2024-03-13T15:00","2024-03-13T16:00","2024-03-13T17:00","2024-03-13T18:00","2024-03-13T19:00","2024-03-13T20:00","2024-03-13T21:00","2024-03-13T22:00","2024-03-13T23:00"],"is_day":[0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0],"temperature_2m":[-1.0,-1.3,-1.7,-1.9,-2.2,-2.2,-2.0,-0.9,0.5,1.9,3.0,3.9,4.6,4.8,4.8,4.3,3.1,1.4,0.3,-0.2,-0.3,-0.6,-1.0,-1.2,-1.5,-1.6,-1.6,-0.9,-0.3,0.1,0.5,0.8,1.2,1.7,2.4,3.3,3.8,4.0,3.8,3.2,2.1,0.8,0.2,-0.3,-0.7,-1.1,-1.5,-1.9,-2.2,-2.6,-2.9,-3.3,-3.7,-3.8,-3.3,-2.0,-0.5,0.8,1.8,2.5,2.6,2.8,2.5,2.1,1.3,0.6,0.4,0.2,-0.3,-0.4,-0.4,-0.6,-0.9,-1.0,-4.0,-3.7,-3.4,-3.2,-2.8,-2.4,-1.8,-1.5,-1.0,-0.9,-0.6,-0.4,-0.5,-0.7,-1.2,-1.5,-1.6,-1.8,-2.0,-2.3,-2.6,-3.0,-3.4,-3.8,-4.1,-4.3,-4.1,-3.7,-3.2,-2.8,-2.4,-1.9,-1.5,-1.0,-0.8,-0.8,-1.0,-1.3,-1.6,-1.9,-2.1,-2.1,-2.0,-1.9,-1.8,-1.7,-1.7,-1.8,-2.0,-2.2,-2.5,-2.8,-2.6,-1.8,-0.6,0.4,0.9,1.1,1.3,1.2,0.9,0.5,-0.0,-0.7,-1.3,-1.8,-2.2,-2.6,-2.8,-3.0,-3.2,-3.3,-3.5,-3.7,-4.1,-4.5,-4.5,-3.6,-2.2,-1.0,-0.1,0.6,1.1,1.3,1.2,1.1,0.7,0.2,-0.2,-0.4,-0.5,-0.6,-0.9,-1.2,-1.5,-1.7,-1.9,-2.0,-2.1,-2.2,-2.2,-2.0,-1.7,-1.2,-0.6,0.2,0.7,0.8,0.7,0.4,-0.1,-0.7,-1.3,-1.6,-1.8,-1.9,-1.9,-1.8,-1.7,-4.4,-5.0,-5.6,-6.1,-6.6,-6.8,-6.4,-5.6,-4.9,-4.2,-3.6,-3.3,-3.3,-3.6,-4.1,-4.6,-5.3,-6.0,-6.6,-7.2,-7.7,-8.0,-8.1,-8.2,-8.4,-8.5,-8.6,-8.5,-8.4,-8.0,-7.2,-6.2,-5.2,-4.3,-3.4,-2.9,-2.7,-2.8,-3.0,-3.3,-3.7,-4.1,-4.3,-4.6,-4.8,-5.0,-5.2],"apparent_temperature":[-4.8,-5.2,-5.6,-5.8,-6.1,-6.2,-6.0,-4.7,-3.2,-1.9,-1.0,-0.2,0.6,0.7,0.7,0.1,-0.7,-2.0,-3.0,-3.6,-4.0,-4.2,-4.7,-5.2,-5.6,-5.7,-6.2,-5.4,-4.9,-4.5,-3.9,-3.5,-3.1,-2.6,-2.0,-1.0,-0.5,-0.2,-0.5,-1.3,-2.2,-3.2,-4.0,-4.5,-5.1,-5.6,-5.8,-6.2,-6.5,-6.7,-7.0,-7.4,-7.8,-7.9,-7.1,-5.7,-4.0,-2.9,-1.9,-1.5,-1.8,-1.8,-2.2,-2.8,-3.3,-3.6,-3.7,-4.1,-4.9,-4.9,-4.6,-4.6,-5.4,-5.2,-7.7,-7.4,-7.1,-7.0,-6.5,-5.9,-5.3,-5.2,-4.7,-4.5,-4.1,-4.0,-4.1,-4.2,-4.5,-4.9,-5.0,-5.2,-5.3,-5.5,-5.9,-6.2,-6.6,-7.0,-7.3,-7.5,-7.3,-7.0,-6.6,-6.4,-6.1,-5.9,-5.5,-5.0,-4.7,-4.8,-4.9,-5.1,-5.3,-5.5,-5.5,-5.5,-5.4,-5.3,-5.1,-4.9,-4.8,-4.9,-5.1,-5.4,-5.7,-6.2,-6.1,-5.2,-4.0,-3.0,-2.6,-2.6,-2.5,-2.4,-2.7,-3.1,-3.6,-4.3,-4.8,-5.2,-5.5,-5.8,-6.1,-6.3,-6.6,-6.8,-7.0,-7.3,-7.6,-8.0,-8.0,-7.3,-6.3,-5.3,-4.6,-3.9,-3.4,-3.1,-2.9,-2.8,-3.2,-3.7,-4.1,-4.3,-4.3,-4.4,-4.6,-4.8,-4.9,-5.1,-5.2,-5.3,-5.4,-5.6,-5.5,-5.3,-5.0,-4.7,-4.2,-3.6,-3.1,-2.9,-2.9,-3.0,-3.3,-3.9,-4.4,-4.7,-5.0,-5.3,-5.3,-5.4,-5.4,-9.7,-10.4,-11.1,-11.9,-12.6,-12.9,-12.5,-11.6,-10.8,-10.2,-9.7,-9.4,-9.5,-9.7,-10.2,-10.6,-11.2,-11.8,-12.3,-12.9,-13.1,-13.3,-13.2,-13.2,-13.3,-13.4,-13.5,-13.4,-13.4,-13.0,-12.2,-11.0,-9.9,-8.7,-7.6,-6.8,-6.4,-6.4,-6.7,-7.1,-7.7,-8.3,-8.6,-9.0,-9.3,-9.6,-9.9],"relativehumidity_2m":[82,84,85,87,88,87,86,80,73,66,61,56,54,53,53,55,63,73,81,84,80,83,84,83,87,90,92,92,89,86,83,81,77,71,63,56,53,52,52,54,60,66,69,70,70,70,72,74,75,77,79,81,82,82,81,73,62,54,49,49,53,50,55,55,60,67,68,70,77,77,79,82,71,69,81,81,82,84,85,85,82,76,74,74,72,70,72,75,81,83,84,86,87,88,90,93,95,97,99,99,97,94,90,87,83,80,78,77,76,77,78,80,82,85,87,88,88,88,89,90,91,90,88,87,87,87,86,82,77,73,71,69,68,69,69,71,74,78,82,84,86,87,88,90,90,89,88,87,88,89,88,82,74,67,63,60,58,58,60,63,67,72,76,79,81,83,85,86,88,90,91,93,94,96,96,95,94,91,87,81,78,78,79,81,84,89,92,94,96,96,93,89,86,61,62,61,56,50,45,43,41,40,38,35,33,32,33,34,36,40,43,46,50,53,55,56,58,61,63,65,65,64,62,57,51,46,42,39,37,36,37,38,40,42,44,45,46,47,47,48],"precipitation_probability":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,3,3,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,1,0,0,0,0,2,4,6,5,4,3,3,3,3,4,5,6,6,6,6,5,4,3,3,3,3,4,5,6,6,6,6,5,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,5,6,6,6,6,7,9,10,10,10],"windspeed_10m":[8.3,8.3,8.6,8.6,8.6,9.0,8.6,8.3,7.6,7.9,9.0,9.7,9.7,9.4,9.7,10.1,8.3,6.1,5.8,6.1,7.6,7.2,7.9,9.7,10.1,10.4,14.8,14.4,15.1,15.5,14.0,13.3,12.6,11.9,11.5,10.8,10.1,9.4,10.8,11.5,10.1,8.3,9.7,10.1,10.8,10.8,9.7,9.7,9.4,8.6,8.6,8.6,8.3,7.9,6.1,5.0,4.0,4.7,4.7,7.2,10.4,10.8,12.6,13.7,12.2,9.7,9.0,10.8,13.0,12.6,10.8,9.7,11.9,9.0,5.2,5.4,5.6,6.4,6.1,5.2,5.9,6.5,6.3,5.7,5.4,5.5,5.5,5.4,4.8,4.6,5.1,4.8,4.3,4.1,3.8,3.3,3.3,3.3,3.6,3.6,3.6,3.8,4.1,5.4,6.9,8.2,8.4,8.7,8.6,8.4,8.1,7.6,6.8,6.0,5.2,5.1,5.1,5.1,4.7,4.2,4.0,3.7,3.2,3.1,3.5,4.4,5.1,5.0,4.8,5.2,6.0,7.2,7.9,6.4,6.4,6.1,6.1,5.9,5.5,5.0,4.2,3.7,3.7,4.0,4.5,5.0,5.0,5.2,4.6,3.8,4.2,5.6,7.9,9.5,10.3,10.6,10.6,9.8,8.4,7.6,7.8,8.0,8.3,8.4,8.2,8.4,7.9,6.7,5.7,5.5,5.5,5.3,5.4,5.8,5.8,5.5,5.6,6.6,7.7,8.4,8.9,8.4,7.3,6.3,5.3,4.7,4.2,4.3,5.2,5.8,6.3,7.0,7.5,13.3,13.8,14.5,15.5,16.6,17.1,16.8,16.0,15.6,15.9,16.5,16.8,16.7,16.6,16.6,15.9,15.3,14.8,14.3,13.8,12.8,11.9,10.7,9.8,9.5,9.4,9.5,9.6,9.9,10.1,9.8,8.7,7.6,6.0,4.2,2.4,1.0,0.5,1.1,1.6,2.9,4.5,5.2,5.9,6.5,7.2,7.9],"winddirection_10m":[86,88,85,83,84,86,92,102,102,93,100,95,88,91,82,86,92,57,46,44,67,57,42,47,46,49,53,58,61,66,69,64,63,67,70,74,77,72,57,59,51,36,44,53,58,61,69,54,57,51,45,44,45,46,50,58,42,26,356,309,302,302,306,307,310,311,313,334,359,356,357,15,40,32,326,323,320,322,332,344,11,34,31,18,360,349,337,323,318,315,321,318,318,315,311,311,311,311,307,307,315,319,322,323,321,319,313,308,303,301,302,301,302,303,304,309,315,321,328,340,350,349,333,324,336,351,352,339,318,304,303,307,309,317,313,310,315,322,328,330,329,331,331,333,331,330,330,326,321,311,301,297,294,295,295,294,294,294,295,295,292,288,288,295,308,317,321,324,325,328,328,332,340,353,353,337,315,299,298,301,302,301,303,301,298,293,290,294,295,300,301,305,305,41,41,42,44,48,48,43,36,29,25,23,23,25,30,34,38,41,43,43,41,38,35,33,28,25,23,25,34,46,55,62,66,71,73,70,63,45,315,252,207,173,166,168,169,174,177,177],"weathercode":[0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,1,0,0,0,1,0,0,0,0,0,3,3,3,3,3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,0,0,0,0,0,0,3,3,3,2,2,2,2,2,2,3,3,3,2,2,2,2,2,2,3,3,3,3,3,3,2,2,2,1,1,1,1,1,1,1,1,1,2,2,2,3,2,2,1,1,0,1,1,2,2,3,3,3,2,2,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},"daily_units":{"time":"iso8601","sunrise":"iso8601","sunset":"iso8601","temperature_2m_min":"°C","temperature_2m_max":"°C","precipitation_sum":"mm","precipitation_probability_max":"%","weathercode":"wmo code"},"daily":{"time":["2024-03-04","2024-03-05","2024-03-06","2024-03-07","2024-03-08","2024-03-09","2024-03-10","2024-03-11","2024-03-12","2024-03-13"],"sunrise":["2024-03-04T04:51","2024-03-05T04:48","2024-03-06T04:45","2024-03-07T04:43","2024-03-08T04:40","2024-03-09T04:37","2024-03-10T04:34","2024-03-11T04:32","2024-03-12T04:29","2024-03-13T04:26"],"sunset":["2024-03-04T15:44","2024-03-05T15:47","2024-03-06T15:49","2024-03-07T15:51","2024-03-08T15:54","2024-03-09T15:56","2024-03-10T15:58","2024-03-11T16:00","2024-03-12T16:03","2024-03-13T16:05"],"temperature_2m_min":[-2.2,-1.9,-3.8,-4.0,-4.3,-3.0,-4.5,-2.2,-8.1,-8.6],"temperature_2m_max":[4.8,4.0,2.8,-0.4,-0.8,1.3,1.3,0.8,-1.7,-2.7],"precipitation_sum":[0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00],"precipitation_probability_max":[0,0,0,0,3,3,3,6,6,10],"weathercode":[1,3,3,3,3,3,3,3,3,0]}}
""".data(using: .utf8)!

let weatherJSONDataMoscow = """
{"latitude":55.75,"longitude":37.625,"generationtime_ms":0.2739429473876953,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":141.0,"current_units":{"time":"iso8601","interval":"seconds","is_day":"","temperature_2m":"°C","apparent_temperature":"°C","relative_humidity_2m":"%","wind_speed_10m":"km/h","wind_direction_10m":"°","weather_code":"wmo code"},"current":{"time":"2024-03-04T18:30","interval":900,"is_day":0,"temperature_2m":-0.2,"apparent_temperature":-3.4,"relative_humidity_2m":61,"wind_speed_10m":1.8,"wind_direction_10m":191,"weather_code":3},"hourly_units":{"time":"iso8601","is_day":"","temperature_2m":"°C","apparent_temperature":"°C","relativehumidity_2m":"%","precipitation_probability":"%","windspeed_10m":"km/h","winddirection_10m":"°","weathercode":"wmo code"},"hourly":{"time":["2024-03-04T00:00","2024-03-04T01:00","2024-03-04T02:00","2024-03-04T03:00","2024-03-04T04:00","2024-03-04T05:00","2024-03-04T06:00","2024-03-04T07:00","2024-03-04T08:00","2024-03-04T09:00","2024-03-04T10:00","2024-03-04T11:00","2024-03-04T12:00","2024-03-04T13:00","2024-03-04T14:00","2024-03-04T15:00","2024-03-04T16:00","2024-03-04T17:00","2024-03-04T18:00","2024-03-04T19:00","2024-03-04T20:00","2024-03-04T21:00","2024-03-04T22:00","2024-03-04T23:00","2024-03-05T00:00","2024-03-05T01:00","2024-03-05T02:00","2024-03-05T03:00","2024-03-05T04:00","2024-03-05T05:00","2024-03-05T06:00","2024-03-05T07:00","2024-03-05T08:00","2024-03-05T09:00","2024-03-05T10:00","2024-03-05T11:00","2024-03-05T12:00","2024-03-05T13:00","2024-03-05T14:00","2024-03-05T15:00","2024-03-05T16:00","2024-03-05T17:00","2024-03-05T18:00","2024-03-05T19:00","2024-03-05T20:00","2024-03-05T21:00","2024-03-05T22:00","2024-03-05T23:00","2024-03-06T00:00","2024-03-06T01:00","2024-03-06T02:00","2024-03-06T03:00","2024-03-06T04:00","2024-03-06T05:00","2024-03-06T06:00","2024-03-06T07:00","2024-03-06T08:00","2024-03-06T09:00","2024-03-06T10:00","2024-03-06T11:00","2024-03-06T12:00","2024-03-06T13:00","2024-03-06T14:00","2024-03-06T15:00","2024-03-06T16:00","2024-03-06T17:00","2024-03-06T18:00","2024-03-06T19:00","2024-03-06T20:00","2024-03-06T21:00","2024-03-06T22:00","2024-03-06T23:00","2024-03-07T00:00","2024-03-07T01:00","2024-03-07T02:00","2024-03-07T03:00","2024-03-07T04:00","2024-03-07T05:00","2024-03-07T06:00","2024-03-07T07:00","2024-03-07T08:00","2024-03-07T09:00","2024-03-07T10:00","2024-03-07T11:00","2024-03-07T12:00","2024-03-07T13:00","2024-03-07T14:00","2024-03-07T15:00","2024-03-07T16:00","2024-03-07T17:00","2024-03-07T18:00","2024-03-07T19:00","2024-03-07T20:00","2024-03-07T21:00","2024-03-07T22:00","2024-03-07T23:00","2024-03-08T00:00","2024-03-08T01:00","2024-03-08T02:00","2024-03-08T03:00","2024-03-08T04:00","2024-03-08T05:00","2024-03-08T06:00","2024-03-08T07:00","2024-03-08T08:00","2024-03-08T09:00","2024-03-08T10:00","2024-03-08T11:00","2024-03-08T12:00","2024-03-08T13:00","2024-03-08T14:00","2024-03-08T15:00","2024-03-08T16:00","2024-03-08T17:00","2024-03-08T18:00","2024-03-08T19:00","2024-03-08T20:00","2024-03-08T21:00","2024-03-08T22:00","2024-03-08T23:00","2024-03-09T00:00","2024-03-09T01:00","2024-03-09T02:00","2024-03-09T03:00","2024-03-09T04:00","2024-03-09T05:00","2024-03-09T06:00","2024-03-09T07:00","2024-03-09T08:00","2024-03-09T09:00","2024-03-09T10:00","2024-03-09T11:00","2024-03-09T12:00","2024-03-09T13:00","2024-03-09T14:00","2024-03-09T15:00","2024-03-09T16:00","2024-03-09T17:00","2024-03-09T18:00","2024-03-09T19:00","2024-03-09T20:00","2024-03-09T21:00","2024-03-09T22:00","2024-03-09T23:00","2024-03-10T00:00","2024-03-10T01:00","2024-03-10T02:00","2024-03-10T03:00","2024-03-10T04:00","2024-03-10T05:00","2024-03-10T06:00","2024-03-10T07:00","2024-03-10T08:00","2024-03-10T09:00","2024-03-10T10:00","2024-03-10T11:00","2024-03-10T12:00","2024-03-10T13:00","2024-03-10T14:00","2024-03-10T15:00","2024-03-10T16:00","2024-03-10T17:00","2024-03-10T18:00","2024-03-10T19:00","2024-03-10T20:00","2024-03-10T21:00","2024-03-10T22:00","2024-03-10T23:00","2024-03-11T00:00","2024-03-11T01:00","2024-03-11T02:00","2024-03-11T03:00","2024-03-11T04:00","2024-03-11T05:00","2024-03-11T06:00","2024-03-11T07:00","2024-03-11T08:00","2024-03-11T09:00","2024-03-11T10:00","2024-03-11T11:00","2024-03-11T12:00","2024-03-11T13:00","2024-03-11T14:00","2024-03-11T15:00","2024-03-11T16:00","2024-03-11T17:00","2024-03-11T18:00","2024-03-11T19:00","2024-03-11T20:00","2024-03-11T21:00","2024-03-11T22:00","2024-03-11T23:00","2024-03-12T00:00","2024-03-12T01:00","2024-03-12T02:00","2024-03-12T03:00","2024-03-12T04:00","2024-03-12T05:00","2024-03-12T06:00","2024-03-12T07:00","2024-03-12T08:00","2024-03-12T09:00","2024-03-12T10:00","2024-03-12T11:00","2024-03-12T12:00","2024-03-12T13:00","2024-03-12T14:00","2024-03-12T15:00","2024-03-12T16:00","2024-03-12T17:00","2024-03-12T18:00","2024-03-12T19:00","2024-03-12T20:00","2024-03-12T21:00","2024-03-12T22:00","2024-03-12T23:00","2024-03-13T00:00","2024-03-13T01:00","2024-03-13T02:00","2024-03-13T03:00","2024-03-13T04:00","2024-03-13T05:00","2024-03-13T06:00","2024-03-13T07:00","2024-03-13T08:00","2024-03-13T09:00","2024-03-13T10:00","2024-03-13T11:00","2024-03-13T12:00","2024-03-13T13:00","2024-03-13T14:00","2024-03-13T15:00","2024-03-13T16:00","2024-03-13T17:00","2024-03-13T18:00","2024-03-13T19:00","2024-03-13T20:00","2024-03-13T21:00","2024-03-13T22:00","2024-03-13T23:00"],"is_day":[0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0],"temperature_2m":[-3.6,-3.8,-4.1,-5.3,-5.6,-5.8,-4.0,-3.6,-2.5,0.1,1.7,3.2,3.5,3.6,3.0,1.7,1.0,0.4,0.0,-0.3,-1.1,-2.0,-2.5,-2.8,-2.9,-3.2,-3.5,-3.8,-4.4,-5.1,-5.7,-5.1,-4.2,-3.0,-1.8,-0.7,-0.3,-0.5,-0.8,-1.6,-2.7,-3.5,-4.0,-4.3,-4.5,-4.7,-4.8,-5.1,-5.6,-6.3,-6.9,-7.6,-8.2,-8.7,-8.7,-8.1,-7.2,-6.2,-5.0,-4.1,-3.3,-2.9,-2.8,-3.0,-3.5,-3.9,-4.3,-4.6,-5.0,-5.4,-5.8,-6.1,-6.5,-6.9,-7.2,-7.6,-7.9,-8.2,-7.9,-7.0,-6.3,-5.3,-4.5,-4.0,-3.8,-3.6,-3.3,-3.3,-3.5,-3.6,-3.7,-3.8,-3.9,-4.1,-4.3,-4.5,-4.6,-4.7,-4.7,-4.7,-4.7,-4.6,-4.4,-3.8,-3.1,-2.4,-1.6,-0.9,-0.3,-0.2,-0.3,-0.6,-0.9,-1.4,-1.9,-2.4,-2.9,-3.4,-3.8,-4.1,-4.5,-4.8,-5.1,-5.4,-5.5,-5.5,-5.4,-4.8,-4.1,-3.5,-3.1,-2.8,-2.7,-2.9,-3.1,-3.4,-3.8,-4.2,-4.6,-4.9,-5.3,-5.6,-5.8,-5.9,-6.0,-6.1,-6.1,-6.1,-6.1,-6.1,-5.7,-4.7,-3.5,-2.4,-1.4,-0.6,-0.2,-0.2,-0.6,-1.0,-1.2,-1.5,-1.7,-1.8,-1.9,-2.0,-2.1,-2.3,-2.4,-2.6,-2.7,-2.9,-3.0,-3.2,-3.0,-2.4,-1.6,-0.9,-0.4,0.0,0.3,0.3,0.1,-0.1,-0.4,-0.7,-1.1,-1.5,-1.9,-2.2,-2.5,-2.7,-2.9,-16.3,-18.0,-18.6,-17.5,-15.2,-13.1,-11.4,-9.8,-8.6,-7.9,-7.5,-7.5,-7.9,-8.7,-9.3,-9.8,-10.1,-10.3,-10.4,-10.3,-10.4,-10.9,-11.6,-12.2,-12.9,-13.5,-14.0,-14.3,-14.4,-14.2,-13.3,-12.1,-11.0,-10.2,-9.6,-9.3,-9.6,-10.3,-11.0,-11.9,-12.9,-13.8,-14.8,-15.7,-16.4,-16.9,-17.1],"apparent_temperature":[-7.2,-7.4,-7.7,-8.9,-9.3,-9.6,-7.6,-7.1,-6.0,-3.5,-2.0,-0.6,-0.3,-0.1,-0.6,-1.8,-2.3,-3.0,-3.2,-3.5,-4.7,-5.5,-6.1,-6.3,-6.5,-6.8,-7.1,-7.5,-8.1,-9.0,-9.8,-9.1,-8.1,-6.9,-5.8,-4.9,-4.7,-4.9,-5.3,-6.1,-7.0,-7.9,-8.5,-8.6,-8.8,-8.7,-9.0,-9.2,-9.9,-10.5,-10.8,-11.5,-12.2,-12.7,-12.7,-12.1,-11.3,-10.3,-9.1,-8.1,-7.5,-7.0,-6.8,-6.8,-7.1,-7.5,-7.9,-8.3,-8.7,-9.1,-9.5,-9.8,-10.2,-10.6,-11.0,-11.4,-11.7,-12.0,-11.7,-11.0,-10.1,-9.2,-8.4,-7.8,-7.6,-7.2,-7.0,-6.9,-6.7,-6.9,-7.2,-7.3,-7.5,-7.7,-8.0,-8.2,-8.5,-8.8,-9.0,-9.1,-9.1,-8.9,-8.6,-8.0,-7.2,-6.5,-5.8,-5.1,-4.5,-4.3,-4.4,-4.6,-4.9,-5.3,-5.8,-6.2,-6.6,-7.0,-7.4,-7.7,-8.0,-8.4,-8.8,-9.2,-9.4,-9.6,-9.6,-9.2,-8.6,-8.2,-7.8,-7.4,-7.2,-7.4,-7.6,-7.8,-8.0,-8.2,-8.5,-8.7,-8.9,-9.2,-9.5,-9.7,-9.8,-10.0,-10.0,-10.1,-10.2,-10.3,-10.0,-9.2,-8.2,-7.3,-6.4,-5.7,-5.1,-4.9,-4.9,-4.9,-5.0,-5.3,-5.4,-5.4,-5.4,-5.4,-5.5,-5.5,-5.6,-5.7,-5.9,-6.1,-6.3,-6.5,-6.5,-6.1,-5.5,-4.8,-4.5,-4.2,-4.0,-3.9,-3.8,-3.9,-4.0,-4.3,-4.7,-5.1,-5.6,-6.0,-6.4,-6.8,-7.1,-21.0,-22.7,-23.3,-22.1,-19.8,-17.8,-16.3,-15.0,-14.0,-13.4,-13.1,-13.1,-13.4,-14.1,-14.7,-15.1,-15.4,-15.7,-16.0,-16.1,-16.5,-17.0,-17.6,-18.2,-18.9,-19.7,-20.2,-20.5,-20.6,-20.4,-19.6,-18.5,-17.5,-16.7,-16.0,-15.8,-16.0,-16.7,-17.3,-18.0,-18.9,-19.6,-20.3,-21.0,-21.6,-22.0,-22.4],"relativehumidity_2m":[74,72,74,81,81,81,73,72,68,57,48,42,41,40,42,50,58,61,61,60,64,70,71,72,72,72,71,71,72,73,82,90,89,86,82,71,63,61,64,71,77,80,80,81,82,82,83,81,84,80,82,84,84,86,84,81,76,70,65,60,55,52,52,58,63,63,63,65,69,72,72,72,73,75,76,77,77,77,75,69,68,66,67,71,79,82,82,83,86,90,90,90,90,89,89,88,88,88,88,88,88,88,88,88,87,86,82,78,75,75,77,79,81,82,84,86,88,89,89,89,89,90,90,90,89,87,84,81,77,74,71,69,67,70,72,75,78,81,84,86,86,87,87,87,87,87,86,85,85,84,82,78,72,67,64,61,62,68,78,86,90,92,93,94,94,94,95,95,95,94,92,90,89,89,87,82,75,69,63,57,54,56,62,67,72,77,81,84,86,87,88,89,90,86,85,84,85,87,88,86,83,80,78,76,75,77,81,84,86,87,87,87,86,86,86,86,86,85,85,84,84,84,84,83,81,80,79,78,78,78,78,79,80,81,82,83,84,84,84,83],"precipitation_probability":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,7,10,12,14,16,11,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,3,3,3,4,5,6,4,2,0,1,2,3,3,3,3,2,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,5,4,3,4,5,6,7,9,10,7,3,0,1,2,3,4,5,6,6,6,6,7,9,10,12,14,16,13,9,6,4,2,0,3,7,10,10,10,10,11,12,13,13,13,13,15,17,19,20,22,23,21,18,16,16,16,16,17,18,19,17,15,13,13,13,13,13,13,13,12,11,10,9,7,6,7,9,10,11,12,13,13,13,13,13,13,13,15,17,19,18,17,16,13,9,6,8,11,13,12,11,10,11,12,13,13,13],"windspeed_10m":[3.5,3.4,3.5,3.8,4.2,4.3,3.8,3.1,3.1,3.9,4.7,5.0,4.7,4.0,3.1,2.9,3.1,3.3,2.2,1.8,4.3,3.7,4.1,3.6,3.6,3.7,4.0,4.1,4.3,5.1,7.1,6.9,7.0,8.1,9.1,9.6,10.2,9.8,10.6,10.5,10.1,10.2,10.4,9.2,8.7,7.1,8.4,7.6,8.2,7.1,5.1,5.1,5.1,4.7,4.7,5.0,5.4,5.4,5.2,5.2,5.6,5.0,4.7,3.5,2.4,2.4,2.5,2.9,3.0,2.9,3.1,3.1,2.9,2.8,3.1,3.3,3.3,3.3,2.9,4.7,3.6,4.4,4.8,5.2,5.4,4.7,5.2,4.6,3.0,3.3,4.8,5.2,5.0,5.4,5.7,5.9,6.6,7.6,9.0,10.1,10.2,9.6,9.2,9.0,9.2,9.7,10.0,10.3,10.3,10.2,9.7,9.4,9.2,8.9,8.4,7.7,6.9,5.9,5.4,4.8,4.7,4.8,5.4,5.8,6.3,7.1,8.3,9.5,10.6,11.5,11.3,10.7,10.2,10.0,9.5,9.1,8.3,7.3,6.2,5.1,4.3,4.4,4.3,4.7,4.7,5.1,5.6,6.0,6.8,7.5,8.6,9.8,11.5,12.6,13.4,13.8,13.5,12.4,10.9,9.4,9.0,8.6,8.3,7.6,7.0,6.3,5.5,4.6,3.9,3.5,3.7,3.6,3.8,4.2,4.9,5.8,6.8,7.4,7.9,8.2,8.4,8.0,7.1,6.5,6.2,6.2,6.3,6.6,7.3,8.0,8.6,9.7,10.5,6.1,5.8,5.8,5.8,6.1,7.2,9.5,12.1,14.2,15.1,15.3,15.1,14.6,14.2,13.8,13.6,13.4,13.8,15.0,16.6,18.0,18.0,17.3,16.9,16.9,17.3,17.3,17.3,17.3,17.6,18.4,19.6,20.3,20.6,20.5,20.5,20.2,19.8,19.1,17.7,16.2,14.4,12.7,10.8,9.7,9.5,10.0],"winddirection_10m":[114,108,114,107,110,114,107,111,126,146,148,150,157,153,159,150,159,174,171,217,228,259,255,264,276,281,297,315,336,356,24,28,21,32,34,34,32,28,28,31,35,39,44,45,48,49,25,19,15,15,8,4,4,360,356,360,4,4,344,344,345,339,337,336,333,333,315,300,284,270,249,249,240,230,234,229,229,229,240,261,270,279,297,295,307,302,304,309,284,276,297,295,291,290,288,284,283,278,275,274,278,283,291,299,309,315,319,324,324,321,315,310,312,313,317,319,321,322,318,312,302,297,290,292,301,315,326,335,342,346,343,340,337,334,331,326,326,327,324,315,294,279,275,274,270,262,255,253,252,253,255,262,268,272,275,277,279,278,276,272,270,268,268,273,282,294,302,315,326,336,349,354,343,329,324,330,335,337,330,322,313,306,300,289,277,263,257,257,261,265,268,272,274,332,330,330,330,332,333,335,337,339,342,345,348,350,351,353,349,346,345,350,358,1,1,360,359,359,360,360,360,360,1,3,6,7,5,2,360,359,358,358,358,357,356,352,345,338,335,334],"weathercode":[0,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,3,3,3,3,77,3,3,2,3,2,2,2,3,3,3,3,3,3,3,2,2,2,1,1,1,0,0,0,2,2,2,1,1,1,1,2,0,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,2,3,3,3,3,3,3,3,3,3,85,3,3,3,3,3,3,3,3,3,71,71,71,3,3,3,2,2,2,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,3,3,3,71,71,71,71,71,71,71,71,71,71,71,71,3,3,3,3,3,3,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,71,71,71,3,3,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,1,1,0,0,0,0]},"daily_units":{"time":"iso8601","sunrise":"iso8601","sunset":"iso8601","temperature_2m_min":"°C","temperature_2m_max":"°C","precipitation_sum":"mm","precipitation_probability_max":"%","weathercode":"wmo code"},"daily":{"time":["2024-03-04","2024-03-05","2024-03-06","2024-03-07","2024-03-08","2024-03-09","2024-03-10","2024-03-11","2024-03-12","2024-03-13"],"sunrise":["2024-03-04T04:11","2024-03-05T04:09","2024-03-06T04:06","2024-03-07T04:03","2024-03-08T04:01","2024-03-09T03:58","2024-03-10T03:56","2024-03-11T03:53","2024-03-12T03:51","2024-03-13T03:48"],"sunset":["2024-03-04T15:10","2024-03-05T15:12","2024-03-06T15:14","2024-03-07T15:16","2024-03-08T15:18","2024-03-09T15:20","2024-03-10T15:23","2024-03-11T15:25","2024-03-12T15:27","2024-03-13T15:29"],"temperature_2m_min":[-5.8,-5.7,-8.7,-8.2,-4.7,-5.9,-6.1,-3.2,-18.6,-17.1],"temperature_2m_max":[3.6,-0.3,-2.8,-3.3,-0.2,-2.7,-0.2,0.3,-2.9,-9.3],"precipitation_sum":[0.00,0.00,0.00,0.00,0.00,0.00,1.70,0.10,0.00,0.00],"precipitation_probability_max":[0,16,0,2,6,10,16,23,19,19],"weathercode":[3,77,2,85,71,3,71,71,71,3]}}
""".data(using: .utf8)!

#endif
