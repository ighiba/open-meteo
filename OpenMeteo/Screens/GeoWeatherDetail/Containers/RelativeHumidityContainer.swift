//
//  RelativeHumidityContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class RelativeHumidityContainer: ContainerView {
    
    override var containerName: String {
        return NSLocalizedString("Relative humidity", comment: "")
    }

    override func setViews() {
        super.setViews()
        self.addSubview(relativeHumidityLabel)

        relativeHumidityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func configure(relativeHumidity: Int16) {
        let relativeHumidityText = String(format: "%i", relativeHumidity) + "%"
        relativeHumidityLabel.setAttributedTextWithShadow(relativeHumidityText)
    }
    
    private let relativeHumidityLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        label.text = "--"
        
        return label
    }()
}
