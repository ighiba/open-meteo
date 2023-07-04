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
    var geocodingListDidChangeHandler: (() -> Void)? { get set }
    func clearGeocodingList()
    func searchTextDidChange(_ searchText: String)
    func searchButtonDidClick(with searchText: String)
}

class GeoSearchViewModel: GeoSearchViewModelDelegate {
    
    var geocodingList: [Geocoding] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.geocodingListDidChangeHandler?()
            }
        }
    }
    
    
    var geocodingListDidChangeHandler: (() -> Void)?
    
    var networkManager: NetworkManager!
    private var searchCancellable: AnyCancellable?
    
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
        searchCancellable?.cancel()

        guard searchString.count > 2 else { return }
        
        let debouncePublsher = PassthroughSubject<String, Never>()
        let debounceInterval: TimeInterval = withDebounce ? 1 : 0
        
        searchCancellable = debouncePublsher
            .debounce(for: .seconds(debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                print("\(Date())  performing search")
                self?.networkManager.fetchSearchResults(for: searchText) { [weak self] result in
                    switch result {
                    case .success(let geocodingList):
                        self?.geocodingList = geocodingList
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        
        debouncePublsher.send(searchString)
    }
}

