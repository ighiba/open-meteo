//
//  Search.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 27.07.2023.
//

import Foundation

extension API {
    enum Search: Endpoint {
        case geocoding(serchText: String)
        
        var baseUrl: URL { return URL(string: "https://geocoding-api.open-meteo.com")! }
        
        var path: String {
            var path = "/v1"
            switch self {
            case .geocoding(_):
                path.append("/search")
            }
            return path
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
            case .geocoding(let searchText):
                let encodedSearchText = encodeQueryParameter(searchText)
                return [
                    URLQueryItem(name: "name", value: encodedSearchText),
                    URLQueryItem(name: "count", value: "10"),
                    URLQueryItem(name: "language", value: Locale.current.languageCode ?? "en"),
                    URLQueryItem(name: "format", value: "json"),
                ]
            }
        }
        
        private func encodeQueryParameter(_ parameter: String) -> String? {
            let allowedCharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
            return parameter.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
        }
    }
}
