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
            snapshot.reloadItems(ids)
            dataSource.apply(snapshot, animatingDifferences: true)
            return
        }

        dataSource.apply(snapshot)
    }
    
    func configureCell(
        collectionView: UICollectionView,
        itemIdentifier: GeoWeather.ID,
        for indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GeoWeatherCell.identifier, for: indexPath)
        guard let weatherCell = cell as? GeoWeatherCell, let geoWeather = geoWeather(withId: itemIdentifier) else { return cell }
        
        weatherCell.configure(with: geoWeather)
        weatherCell.longTapEndedCallback = { [weak self] in 
            self?.openDetail(for: indexPath)
        }
        weatherCell.deleteButtonTappedHandler = { [weak self] in
            let id = geoWeather.id
            self?.removeItem(withId: id)
        }
        
        if isEditing && !isAnimatingEditing {
            weatherCell.startEditing(animated: false)
        } else if !isEditing && weatherCell.isEditing {
            weatherCell.endEditing(animated: false)
        }
        
        return weatherCell
    }
    
    func removeItem(withId id: GeoWeather.ID) {
        viewModel.deleteGeoWeather(withId: id)
    }
    
    func geoWeather(withId id: GeoWeather.ID) -> GeoWeather? {
        return viewModel.geoWeatherList.item(withId: id)
    }
}
