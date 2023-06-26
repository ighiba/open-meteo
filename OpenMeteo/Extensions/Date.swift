//
//  Date.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 26.06.2023.
//

import Foundation

extension Date {
    func string(withFormat dateFormat: String) -> String {
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = dateFormat
        return fullDateFormatter.string(from: self)
    }
}
