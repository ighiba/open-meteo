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
            
            let model = GeoListModel()
            model.geoList.append(objectsIn: geoModelList)
            
            realm.add(model, update: .modified)
        }
    }
    
    func obtainGeoModelList() -> [GeoModel] {
        guard let model = realm.object(ofType: GeoListModel.self, forPrimaryKey: 0) else { return [] }
        return Array(model.geoList)
    }
    
    func delete(geoModelWithId id: Int) {
        guard let model = realm.object(ofType: GeoListModel.self, forPrimaryKey: 0),
              let index = model.geoList.firstIndex(where: { $0.id == id })
        else {
            return
        }

        try? realm.write {
            model.geoList.remove(at: index)
        }
    }
}
