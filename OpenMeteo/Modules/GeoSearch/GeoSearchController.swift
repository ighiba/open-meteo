//
//  GeoSearchController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit

protocol GeoWeatherListViewControllerDelegate {
    func isGeoAlreadyAdded(withId id: Geocoding.ID) -> Bool
    func addGeoWeather(_ geoWeather: GeoWeather)
    func showDimmedView()
    func hideDimmedView()
}

class GeoSearchViewController: UISearchController {
    
    // MARK: - Properties

    var viewModel: GeoSearchViewModelDelegate! {
        didSet {
            viewModel.geocodingListDidChangeHandler = { [weak self] in
                self?.updateSnapshot()
            }
        }
    }
    
    var dataSource: DataSource!
    
    var geoWeatherListViewControllerDelegate: GeoWeatherListViewControllerDelegate?
    var searchBarDelegate: SearchBarDelegate! {
        didSet {
            self.searchBar.delegate = searchBarDelegate
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
        self.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        self.searchBar.searchBarStyle = .prominent
        self.obscuresBackgroundDuringPresentation = false
        
        resultsTableViewController.tableView.delegate = self
        resultsTableViewController.tableView.dataSource = dataSource
        resultsTableViewController.tableView.register(GeocodingCell.self, forCellReuseIdentifier: GeocodingCell.identifier)
        
        dataSource = DataSource(tableView: resultsTableViewController.tableView) { tableView, indexPath, itemIdentifier in
            return self.configureCell(tableView: tableView, itemIdentifier: itemIdentifier, for: indexPath)
        }
        
        searchBarDelegate = SearchBarDelegate(textDidChangeHandler: { [weak self] searchText in
            self?.viewModel.searchTextDidChange(searchText)
        }, searchDidClickHandler: { [weak self] searchText in
            self?.viewModel.searchButtonDidClick(with: searchText)
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

        let isAlreadyAdded = geoWeatherListViewControllerDelegate?.isGeoAlreadyAdded(withId: geocoding.id) ?? false
        detailViewController.navigationBarConfiguration = .add(isAlreadyAdded: isAlreadyAdded)
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
        geoWeatherListViewControllerDelegate?.showDimmedView()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        geoWeatherListViewControllerDelegate?.hideDimmedView()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.clearGeocodingList()
    }
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

class SearchBarDelegate: NSObject, UISearchBarDelegate {
    
    var textDidChangeHandler: ((String) -> Void)?
    var searchDidClickHandler: ((String) -> Void)?
    
    init(textDidChangeHandler: ((String) -> Void)?, searchDidClickHandler: ((String) -> Void)?) {
        self.textDidChangeHandler = textDidChangeHandler
        self.searchDidClickHandler = searchDidClickHandler
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchDidClickHandler?(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        textDidChangeHandler?(searchText)
    }
}


