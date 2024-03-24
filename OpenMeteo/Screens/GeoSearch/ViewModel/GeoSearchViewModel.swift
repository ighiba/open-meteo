//
//  GeoSearchViewModel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 03.07.2023.
//

import Foundation
import Combine

protocol GeoSearchViewModelDelegate: AnyObject {
    var geocodingList: [Geocoding] { get }
    var geocodingListPublisher: Published<[Geocoding]>.Publisher { get }
    func clearGeocodingList()
    func searchTextDidChange(_ searchText: String)
    func searchButtonDidClick(with searchText: String)
}

final class GeoSearchViewModel: GeoSearchViewModelDelegate {
    
    // MARK: - Properties

    @Published var geocodingList: [Geocoding] = []
    var geocodingListPublisher: Published<[Geocoding]>.Publisher { $geocodingList }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let networkManager: NetworkManager
    
    // MARK: - Init
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    // MARK: - Methods
    
    func clearGeocodingList() {
        geocodingList = []
    }
    
    func searchTextDidChange(_ searchText: String) {
        performSearch(with: searchText, withDebounce: true)
    }
    
    func searchButtonDidClick(with searchText: String) {
        performSearch(with: searchText, withDebounce: false)
    }

    private func performSearch(with searchString: String, withDebounce: Bool) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        guard searchString.count > 2 else { return }
        
        let searchPublisher = PassthroughSubject<String, Never>()
        let debounceInterval: TimeInterval = withDebounce ? 0.5 : 0.0
        
        searchPublisher
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.fetchSearchResults(forText: searchText)
            }
            .store(in: &cancellables)
        
        searchPublisher.send(searchString)
    }
    
    private func fetchSearchResults(forText searchText: String) {
        networkManager.fetchSearchResults(endpoint: .geocoding(serchText: searchText))
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Search fetch error: \(error)")
                }
            } receiveValue: { [weak self] geocodingList in
                self?.geocodingList = geocodingList
            }
            .store(in: &cancellables)
    }
}
