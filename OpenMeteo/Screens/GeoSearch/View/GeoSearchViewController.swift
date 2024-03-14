//
//  GeoSearchViewController.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import UIKit
import Combine

protocol GeoWeatherListViewControllerDelegate {
    func isGeoAlreadyAdded(withId id: Geocoding.ID) -> Bool
    func addGeoWeather(_ geoWeather: GeoWeather)
    func showDimmedView()
    func hideDimmedView()
}

final class GeoSearchViewController: UISearchController {
    
    // MARK: - Properties

    var viewModel: GeoSearchViewModelDelegate!
    
    var dataSource: DataSource!
    
    var geoWeatherListViewControllerDelegate: GeoWeatherListViewControllerDelegate?
    private var searchBarDelegate: SearchBarDelegate?
    
    private let resultsTableViewController = UITableViewController(style: .plain)
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        super.init(searchResultsController: resultsTableViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        obscuresBackgroundDuringPresentation = false
        
        resultsTableViewController.tableView.delegate = self
        resultsTableViewController.tableView.dataSource = dataSource
        resultsTableViewController.tableView.register(GeocodingCell.self, forCellReuseIdentifier: GeocodingCell.identifier)
        
        dataSource = DataSource(tableView: resultsTableViewController.tableView) { tableView, indexPath, itemIdentifier in
            return self.configureCell(tableView: tableView, itemIdentifier: itemIdentifier, for: indexPath)
        }
        
        setupSearchBar()
        setupBindings()
        
        updateSnapshot()
    }
    
    // MARK: - Methods
    
    private func setupSearchBar() {
        searchBarDelegate = SearchBarDelegate(textDidChangeHandler: viewModel.searchTextDidChange, searchDidClickHandler: viewModel.searchButtonDidClick)
        
        searchBar.delegate = searchBarDelegate
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.searchBarStyle = .prominent
    }
    
    private func setupBindings() {
        viewModel.geocodingListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }
            .store(in: &cancellables)
    }
    
    private func openDetailAdd(for indexPath: IndexPath) {
        guard let geocoding = geocoding(atIndexPath: indexPath),
              let detailViewController = GeoWeatherDetailModuleAssembly.configureModule(with: geocoding) as? GeoWeatherDetailViewController
        else {
            return
        }
        
        let isAlreadyAdded = geoWeatherListViewControllerDelegate?.isGeoAlreadyAdded(withId: geocoding.id) ?? false
        let isAllowedToAdd = !isAlreadyAdded
        detailViewController.navigationBarConfiguration = .addNew(isAllowedToAdd: isAllowedToAdd)
        detailViewController.geoWeatherDidAdd = { [weak self] geoWeather in
            self?.geoWeatherListViewControllerDelegate?.addGeoWeather(geoWeather)
            self?.geoWeatherListViewControllerDelegate?.hideDimmedView()
            self?.viewModel.clearGeocodingList()
            self?.searchBar.text = nil
            self?.dismiss(animated: true)
        }
        
        let navigationController = UINavigationController(rootViewController: detailViewController)
        present(navigationController, animated: true)
    }
    
    private func geocoding(atIndexPath indexPath: IndexPath) -> Geocoding? {
        return viewModel.geocodingList.item(atIndex: indexPath.row)
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
