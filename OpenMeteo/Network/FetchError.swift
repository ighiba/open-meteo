//
//  FetchError.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 04.07.2023.
//

import Foundation

enum FetchError: Error {
    case stringQueryError
    case urlError
    case networkError(statusCode: Int)
    case decodeError
    case unknown
}
