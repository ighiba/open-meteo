//
//  GeoSearchViewController+DataSource.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 06.07.2023.
//

import UIKit

extension GeoSearchViewController {

    typealias DataSource = UITableViewDiffableDataSource<Int, Geocoding.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Geocoding.ID>
    
    func updateSnapshot() {
        let items = viewModel.geocodingList.map { $0.id }
        
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func configureCell(
        tableView: UITableView,
        itemIdentifier: Geocoding.ID,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GeocodingCell.identifier, for: indexPath)
        guard let geocodingCell = cell as? GeocodingCell,
              let geocoding = viewModel.geocodingList.item(withId: itemIdentifier)
        else {
            return cell
        }
        
        geocodingCell.setupCell(geocoding: geocoding)
        
        return geocodingCell
    }
}
