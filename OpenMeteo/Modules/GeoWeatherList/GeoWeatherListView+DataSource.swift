//
//  GeoWeatherListView+DataSource.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

// MARK: - DataSource

extension GeoWeatherListViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, GeoWeather.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, GeoWeather.ID>
    
    func updateSnapshot(reloading idsThatChanged: [GeoWeather.ID] = []) {
        let ids = idsThatChanged.filter { id in viewModel.geoWeatherList.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.geoWeatherList.map { $0.id } )
        if !ids.isEmpty {
            dataSource.apply(snapshot)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureCell(
        collectionView: UICollectionView,
        itemIdentifier: GeoWeather.ID,
        for indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeoWeatherCell.identifier, for: indexPath)
        
        guard let weatherCell = cell as? GeoWeatherCell, let geoWeather = geoWeather(withId: itemIdentifier) else { return cell }
        
        weatherCell.configure(with: geoWeather)
        
        return weatherCell
    }
    
    func geoWeather(withId id: GeoWeather.ID) -> GeoWeather? {
        if let index = indexOfGeoWeather(for: id) {
            return viewModel.geoWeatherList[index]
        }
        return nil
    }
    
    func indexOfGeoWeather(for id: GeoWeather.ID) -> Int? {
        return viewModel.geoWeatherList.firstIndex { $0.id == id }
    }
}
