//
//  GeoSearchView+DataSource.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 06.07.2023.
//

import UIKit

extension GeoSearchViewController {

    typealias DataSource = UITableViewDiffableDataSource<Int, Geocoding.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Geocoding.ID>
    
    func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.geocodingList.map { $0.id })
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureCell(
        tableView: UITableView,
        itemIdentifier: Geocoding.ID,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GeocodingCell.identifier, for: indexPath)
        guard let geocodingCell = cell as? GeocodingCell, let geocoding = geocoding(withId: itemIdentifier) else { return cell }
        
        geocodingCell.setupCell(geocoding: geocoding)
        
        return geocodingCell
    }
    
    func geocoding(withId id: Geocoding.ID) -> Geocoding? {
        if let index = indexOfGeoWeather(for: id) {
            return viewModel.geocodingList[index]
        }
        return nil
    }
    
    func indexOfGeoWeather(for id: Geocoding.ID) -> Int? {
        return viewModel.geocodingList.firstIndex { $0.id == id }
    }
}
