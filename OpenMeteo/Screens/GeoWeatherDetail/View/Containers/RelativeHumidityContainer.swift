//
//  RelativeHumidityContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class RelativeHumidityContainer: ContainerView {
    
    override var title: String { NSLocalizedString("Relative humidity", comment: "") }
    
    // MARK: - Methods

    override func setupViews() {
        super.setupViews()
        
        addSubview(relativeHumidityLabel)

        relativeHumidityLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func setup(withRelativeHumidity relativeHumidity: Int16) {
        let relativeHumidityText = String(format: "%i", relativeHumidity) + "%"
        relativeHumidityLabel.setAttributedTextWithShadow(relativeHumidityText)
    }
    
    // MARK: - Views
    
    private let relativeHumidityLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        label.text = "--"
        
        return label
    }()
}
