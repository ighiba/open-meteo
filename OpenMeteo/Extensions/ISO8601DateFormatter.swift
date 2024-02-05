//
//  ISO8601DateFormatter.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 05.02.2024.
//

import Foundation

extension ISO8601DateFormatter {
    convenience init(formatOptions: ISO8601DateFormatter.Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}
