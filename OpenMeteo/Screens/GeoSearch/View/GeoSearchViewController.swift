//
//  GeoSearchController.swift
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

class GeoSearchViewController: UISearchController {
    
    // MARK: - Properties

    var viewModel: GeoSearchViewModelDelegate!
    
    var dataSource: DataSource!
    
    var geoWeatherListViewControllerDelegate: GeoWeatherListViewControllerDelegate?
    var searchBarDelegate: SearchBarDelegate! {
        didSet {
            self.searchBar.delegate = searchBarDelegate
        }
    }
    
    var resultsTableViewController = UITableViewController(style: .plain)
    
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
        
        configureBindings()

        updateSnapshot()
    }
    
    private func configureBindings() {
        viewModel.geocodingListPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateSnapshot()
            }
            .store(in: &cancellables)
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
        detailViewController.geoWeatherDidAdd = { [weak self] geoWeather in
            self?.geoWeatherListViewControllerDelegate?.addGeoWeather(geoWeather)
            self?.geoWeatherListViewControllerDelegate?.hideDimmedView()
            self?.viewModel.clearGeocodingList()
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
