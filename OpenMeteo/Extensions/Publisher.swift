//
//  Publisher.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.03.2024.
//

import Foundation
import Combine

extension Publisher where Output == Void {
    public func sink(receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void)) -> AnyCancellable {
        return sink(receiveCompletion: receiveCompletion, receiveValue: { _ in })
    }
}
