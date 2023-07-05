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
    func geoModelList() -> [GeoModel]
}

class DataManagerImpl: DataManager {
    
    lazy var realm = try! Realm(configuration: .defaultConfiguration)

    func save(_ geoModelList: [GeoModel]) {
        try? realm.write {
            realm.add(geoModelList, update: .modified)
        }
    }
    
    func geoModelList() -> [GeoModel] {
        let models = realm.objects(GeoModel.self)
        return Array(models)
    }
}
