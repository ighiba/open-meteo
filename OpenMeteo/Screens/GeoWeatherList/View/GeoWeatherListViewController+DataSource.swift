//
//  GeoWeatherListViewController+DataSource.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 25.06.2023.
//

import UIKit

extension GeoWeatherListViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, GeoWeather.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, GeoWeather.ID>
    
    func updateSnapshot(reloading idsThatChanged: [GeoWeather.ID] = []) {
        let itemsToReload = idsThatChanged.filter { id in viewModel.geoWeatherList.contains(where: { $0.id == id }) }
        let items = viewModel.geoWeatherList.map { $0.id }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        if !itemsToReload.isEmpty {
            snapshot.reloadItems(itemsToReload)
            dataSource.apply(snapshot, animatingDifferences: true) { [weak self] in
                self?.handleRefreshControlEnd()
            }
        } else {
            dataSource.apply(snapshot) { [weak self] in
                self?.handleRefreshControlEnd()
            }
        }
    }
    
    func configureCell(
        collectionView: UICollectionView,
        itemIdentifier: GeoWeather.ID,
        for indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeoWeatherCell.identifier, for: indexPath)
        guard let geoWeatherCell = cell as? GeoWeatherCell,
              let geoWeather = viewModel.geoWeatherList.item(withId: itemIdentifier)
        else {
            return cell
        }
        
        geoWeatherCell.update(with: geoWeather)
        geoWeatherCell.longPressDidEndHandler = { [weak self] in 
            self?.openDetail(for: indexPath)
        }
        geoWeatherCell.deleteButtonDidTapHandler = { [weak self] in
            let id = geoWeather.id
            self?.removeItem(withId: id)
        }
        
        if isEditing && !isAnimatingEditing {
            geoWeatherCell.startEditing(animated: false)
        } else if !isEditing && geoWeatherCell.isEditing {
            geoWeatherCell.endEditing(animated: false)
        }
        
        return geoWeatherCell
    }
    
    func removeItem(withId id: GeoWeather.ID) {
        viewModel.deleteGeoWeather(withId: id)
    }
}
