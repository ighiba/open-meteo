//
//  GeoSearchController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit

protocol GeoWeatherListViewControllerDelegate {
    func addGeoWeather(_ geoWeather: GeoWeather)
    func showDimmedView()
    func hideDimmedView()
}

class GeoSearchViewController: UISearchController {
    
    // MARK: - Properties

    var viewModel: GeoSearchViewModelDelegate! {
        didSet {
            viewModel.geocodingListDidChangedHandler = { [weak self] geocodingList in
                self?.updateSnapshot()
            }
        }
    }
    
    var dataSource: DataSource!
    var geoWeatherListViewControllerDelegate: GeoWeatherListViewControllerDelegate?
    var searchResultsUpdaterDelegate: SearchResultsUpdatingDelegate! {
        didSet {
            self.searchResultsUpdater = searchResultsUpdaterDelegate
        }
    }
    
    var resultsTableViewController: UITableViewController!
    
    // MARK: - Init
    
    init() {
        resultsTableViewController = UITableViewController(style: .plain)
        super.init(searchResultsController: resultsTableViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        self.searchBar.searchBarStyle = .prominent
        self.obscuresBackgroundDuringPresentation = false
        
        resultsTableViewController.tableView.delegate = self
        resultsTableViewController.tableView.dataSource = dataSource
        resultsTableViewController.tableView.register(GeocodingCell.self, forCellReuseIdentifier: GeocodingCell.identifier)
        
        dataSource = DataSource(tableView: resultsTableViewController.tableView) { tableView, indexPath, itemIdentifier in
            return self.configureCell(tableView: tableView, itemIdentifier: itemIdentifier, for: indexPath)
        }
        
        searchResultsUpdaterDelegate = SearchResultsUpdatingDelegate(searchResultsUpdateHandler: { [weak self] searchString in
            self?.viewModel.search(string: searchString)
        })

        updateSnapshot()
    }
    
    // MARK: - Methods
    
    func openDetailAdd(for indexPath: IndexPath) {
        guard let geocoding = geocoding(withIndexPath: indexPath),
              let detailViewController = GeoWeatherDetailModuleAssembly.configureModule(with: geocoding) as? GeoWeatherDetailViewController else {
            return
        }

        let navigationController = UINavigationController(rootViewController: detailViewController)

        detailViewController.navigationBarConfiguration = .add
        detailViewController.didAddedCallback = { [weak self] geoWeather in
            self?.geoWeatherListViewControllerDelegate?.addGeoWeather(geoWeather)
            self?.geoWeatherListViewControllerDelegate?.hideDimmedView()
            self?.searchBar.text = nil
            self?.dismiss(animated: true)
        }
        
        self.present(navigationController, animated: true)
    }
    
    func geocoding(withIndexPath indexPath: IndexPath) -> Geocoding? {
        guard indexPath.row <= viewModel.geocodingList.count else { return nil }
        return viewModel.geocodingList[indexPath.row]
    }
}

extension GeoSearchViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        print("willPresentSearchController")
        self.geoWeatherListViewControllerDelegate?.showDimmedView()
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        print("willDismissSearchController")
        self.geoWeatherListViewControllerDelegate?.hideDimmedView()
    }
}

extension GeoSearchViewController: UISearchBarDelegate {
    
}

// MARK: - Table Delegate

extension GeoSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openDetailAdd(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Table DataSource

extension GeoSearchViewController {

    typealias DataSource = UITableViewDiffableDataSource<Int, Geocoding.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Geocoding.ID>
    
    func updateSnapshot(reloading idsThatChanged: [Geocoding.ID] = []) {
        let ids = idsThatChanged.filter { id in viewModel.geocodingList.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.geocodingList.map { $0.id } )
        if !ids.isEmpty {
            dataSource.apply(snapshot)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureCell(
        tableView: UITableView,
        itemIdentifier: Geocoding.ID,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GeocodingCell.identifier, for: indexPath)
        guard let geocodingCell = cell as? GeocodingCell, let geocoding = geocoding(withId: itemIdentifier) else { return cell }
        
        geocodingCell.configure(with: geocoding)
        
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

class SearchResultsUpdatingDelegate: NSObject, UISearchResultsUpdating {
    
    var searchResultsUpdateHandler: ((String) -> Void)
    
    init(searchResultsUpdateHandler: @escaping ((String) -> Void)) {
        self.searchResultsUpdateHandler = searchResultsUpdateHandler
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else { return }
        print("need update for text \(searchText) ")
        searchResultsUpdateHandler(searchText)
    }
}


