//
//  PrecipitationProbabilityLabel.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 30.06.2023.
//

import UIKit

class PrecipitationProbabilityLabel: UILabel {
    
    private let minProbabilityToShow: Int16
    
    init(minProbabilityToShow: Int16 = 30) {
        self.minProbabilityToShow = minProbabilityToShow
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrecipitationProbability(_ value: Int16) {
        let text = value >= minProbabilityToShow ? "\(value)%" : ""
        self.setAttributedTextWithShadow(text)
    }
}
