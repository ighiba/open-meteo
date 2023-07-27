//
//  DecodableResult.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.07.2023.
//

import Foundation

protocol DecodableResult<T>: Decodable {
    associatedtype T
    var result: T { get set }
}
