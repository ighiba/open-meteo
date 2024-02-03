//
//  SearchBarDelegate.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 07.07.2023.
//

import UIKit

final class SearchBarDelegate: NSObject, UISearchBarDelegate {
    
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
