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
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case country
        case adminLocation = "admin1"
    }

    init(id: Int, name: String, latitude: Float, longitude: Float, country: String, adminLocation: String) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.adminLocation = adminLocation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.latitude = try container.decode(Float.self, forKey: .latitude)
        self.longitude = try container.decode(Float.self, forKey: .longitude)
        self.country = try container.decode(String.self, forKey: .country)
        self.adminLocation = (try? container.decode(String.self, forKey: .adminLocation)) ?? ""
    }
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
