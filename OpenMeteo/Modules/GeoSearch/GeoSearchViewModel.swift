//
//  GeoSearchViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import Foundation

protocol GeoSearchViewModelDelegate: AnyObject {
    var geocodingList: [Geocoding] { get }
    var geocodingListDidChangedHandler: (([Geocoding]) -> Void)? { get set }
    func search(string: String)
}

class GeoSearchViewModel: GeoSearchViewModelDelegate {
    
    var geocodingList: [Geocoding] = [] {
        didSet {
            geocodingListDidChangedHandler?(geocodingList)
        }
    }
    
    var geocodingListDidChangedHandler: (([Geocoding]) -> Void)?
    
    init() {
        geocodingList = GeoWeather.sampleData.map { $0.geocoding }
    }
    
    func search(string: String) {

    }
}

