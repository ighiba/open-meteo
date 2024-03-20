//
//  GeoModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 05.07.2023.
//

import Foundation
import RealmSwift

@objcMembers
final class GeoModel: Object {
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var latitude: Float = 0
    @Persisted var longitude: Float = 0
    @Persisted var country: String = ""
    @Persisted var adminLocation: String = ""
    
    override init() {
        super.init()
    }
 
    init(id: Int, name: String, latitude: Float, longitude: Float, country: String, adminLocation: String) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.adminLocation = adminLocation
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}

extension GeoModel {
    convenience init(geocoding: Geocoding) {
        self.init(
            id: geocoding.id,
            name: geocoding.name,
            latitude: geocoding.latitude,
            longitude: geocoding.longitude,
            country: geocoding.country,
            adminLocation: geocoding.adminLocation
        )
    }
}
