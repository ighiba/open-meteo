//
//  Array+Identifiable.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 17.07.2023.
//

import Foundation

extension Array where Element: Identifiable {
    func item(withId id: Element.ID) -> Element? {
        if let index = index(for: id) {
            return self[index]
        }
        return nil
    }
    
    func index(for id: Element.ID) -> Int? {
        return firstIndex { $0.id == id }
    }
}
