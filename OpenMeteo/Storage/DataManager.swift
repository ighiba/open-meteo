//
//  DataManager.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 05.07.2023.
//

import Foundation
import RealmSwift

protocol DataManager: AnyObject {
    func save(_ geoModelList: [GeoModel])
    func obtainGeoModelList() -> [GeoModel]
    func delete(geoModelWithId id: Int)
}

class DataManagerImpl: DataManager {
    
    lazy var realm = try! Realm(configuration: .defaultConfiguration)

    func save(_ geoModelList: [GeoModel]) {
        try? realm.write {
            realm.add(geoModelList, update: .modified)
        }
    }
    
    func obtainGeoModelList() -> [GeoModel] {
        let models = realm.objects(GeoModel.self)
        return Array(models)
    }
    
    func delete(geoModelWithId id: Int) {
        guard let model = realm.object(ofType: GeoModel.self, forPrimaryKey: id) else { return }
        try? realm.write {
            realm.delete(model)
        }
    }
}
