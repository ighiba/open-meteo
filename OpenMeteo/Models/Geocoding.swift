//
//  Geocoding.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

struct Geocoding: Identifiable, Codable {
    var id: Int
    var name: String
    var latitude: Float
    var longitude: Float
    var country: String
    var adminLocation: String
}

extension Geocoding {
    init(geoModel: GeoModel) {
        self.id = geoModel.id
        self.name = geoModel.name
        self.latitude = geoModel.latitude
        self.longitude = geoModel.longitude
        self.country = geoModel.country
        self.adminLocation = geoModel.adminLocation
    }
}
