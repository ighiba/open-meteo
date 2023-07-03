//
//  GeoWeatherListViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

protocol GeoWeatherListViewModelDelegate: AnyObject {
    var geoWeatherList: [GeoWeather] { get }
    var geoWeatherListDidChangedHandler: (([GeoWeather]) -> Void)? { get set }
    var geoWeatherIdsDidChangedHandler: (([GeoWeather.ID]) -> Void)? { get set }
    func addGeoWeather(_ geoWeather: GeoWeather)
}

class GeoWeatherListViewModel: GeoWeatherListViewModelDelegate {

    var geoWeatherList: [GeoWeather] = [] {
        didSet {
            geoWeatherListDidChangedHandler?(geoWeatherList)
        }
    }
    
    var geoWeatherListDidChangedHandler: (([GeoWeather]) -> Void)?
    var geoWeatherIdsDidChangedHandler: (([GeoWeather.ID]) -> Void)?
    
    init() {
        geoWeatherList = GeoWeather.sampleData
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            let spb = geoWeatherList[2]
            let weather = geoWeatherList[0].weather!
            self.geoWeatherList[2].weather = weather
            self.geoWeatherIdsDidChangedHandler?([spb.id])
        }
    }
    
    func addGeoWeather(_ geoWeather: GeoWeather) {
        #if DEBUG
        let ids = geoWeatherList.map { $0.id }
        guard !ids.contains(geoWeather.id) else { return }
        
        geoWeatherList = geoWeatherList + [geoWeather]
        
        if geoWeather.weather == nil {
            DispatchQueue.global().async {
                sleep(4)
                DispatchQueue.main.sync { [self] in
                    let weather = GeoWeather.sampleData[0].weather!
                    if let index = self.geoWeatherIndex(withId: geoWeather.id) {
                        self.geoWeatherList[index].weather = weather
                        self.geoWeatherIdsDidChangedHandler?([geoWeather.id])
                    }
                }
            }
        }
        #endif
    }
    
    private func geoWeatherIndex(withId id: GeoWeather.ID) -> Int? {
        return geoWeatherList.firstIndex { $0.id == id }
    }
    
    private func geoWeather(withId id: GeoWeather.ID) -> GeoWeather? {
        return geoWeatherList.first { $0.id == id }
    }
    
}

