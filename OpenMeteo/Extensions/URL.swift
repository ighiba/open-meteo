//
//  URL.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 04.07.2023.
//

import Foundation

extension URL {
    func appending(params: [String: String]) -> URL? {
        var urlString = self.absoluteString
        var isNotStartedAppending = true
        for (key, value) in params {
            let leadingSymbol = isNotStartedAppending ? "?" : "&"
            urlString.append("\(leadingSymbol)\(key)=\(value)")
            isNotStartedAppending = false
        }
        return URL(string: urlString)
    }
}
