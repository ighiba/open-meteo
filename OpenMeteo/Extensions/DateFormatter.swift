//
//  DateFormatter.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 05.02.2024.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
