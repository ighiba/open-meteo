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

final class DataManagerImpl: DataManager {
    
    // MARK: - Properties
    
    private let config = Realm.Configuration(
        schemaVersion: 3,
        migrationBlock: { migration, oldSchemaVersion in
            if oldSchemaVersion < 2 {
                migration.enumerateObjects(ofType: GeoModel.className()) { oldObject, newObject in
                    newObject?[#keyPath(GeoModel.adminLocation)] = ""
                }
            }
            if oldSchemaVersion < 3 {
                migration.renameProperty(onType: GeoListModel.className(), from: "geoList", to: "list")
            }
        }
    )
    
    lazy var realm = try! Realm(configuration: config)
    
    // MARK: - Methods

    func save(_ geoModelList: [GeoModel]) {
        try? realm.write {
            let geoListModel = GeoListModel()
            geoListModel.list.append(objectsIn: geoModelList)
            realm.add(geoListModel, update: .modified)
        }
    }
    
    func delete(geoModelWithId id: Int) {
        guard let geoListModel = realm.object(ofType: GeoListModel.self, forPrimaryKey: 0),
              let index = geoListModel.list.firstIndex(where: { $0.id == id })
        else {
            return
        }

        try? realm.write {
            geoListModel.list.remove(at: index)
        }
    }
    
    func obtainGeoModelList() -> [GeoModel] {
        guard let geoListModel = realm.object(ofType: GeoListModel.self, forPrimaryKey: 0) else { return [] }
        return Array(geoListModel.list)
    }
}
