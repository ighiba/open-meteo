//
//  GeocodingJSON.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import Foundation

final class GeocodingJSON: Decodable {
    
    private(set) var geocodingList: [Geocoding]

    enum RootCodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        let resultGeocodingList = try? rootContainer.decode([Geocoding].self, forKey: .results)

        self.geocodingList = resultGeocodingList ?? []
    }
}
