//
//  WeatherListView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 24.06.2023.
//

import UIKit

class WeatherListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Setup view

        setNeedsUpdateConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {

        // Setup constraints
        
        super.updateConstraints()
    }
}

