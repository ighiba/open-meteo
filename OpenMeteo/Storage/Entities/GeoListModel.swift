//
//  GeoListModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 06.07.2023.
//

import Foundation
import RealmSwift

@objcMembers
class GeoListModel: Object {
    @Persisted var id: Int = 0
    @Persisted var geoList: List<GeoModel> = List()
    
    override init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return #keyPath(id)
    }
}
