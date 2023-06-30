//
//  CAShapeLayer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 30.06.2023.
//

import QuartzCore

extension CAShapeLayer {
    convenience init(with path: CGPath?) {
        self.init()
        self.path = path
    }
}
