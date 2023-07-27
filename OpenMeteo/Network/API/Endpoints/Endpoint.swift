//
//  Endpoint.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 27.07.2023.
//

import Foundation

protocol Endpoint {
    var baseUrl: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL? { get }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
