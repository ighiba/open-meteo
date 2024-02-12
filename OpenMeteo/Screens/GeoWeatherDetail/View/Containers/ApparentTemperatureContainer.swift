//
//  ApparentTemperatureContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

final class ApparentTemperatureContainer: ContainerView {
    
    // MARK: - Properties
    
    enum ApparentTemperatureType {
        case equal
        case warmer(Float)
        case colder(Float)
        
        var localizedDescription: String {
            switch self {
            case .equal:
                return NSLocalizedString("No difference", comment: "")
            case .warmer(let difference):
                return String(format: NSLocalizedString("Warmer by %.0f°", comment: ""), difference)
            case .colder(let difference):
                return String(format: NSLocalizedString("Colder by %.0f°", comment: ""), difference)
            }
        }

        static func compareTemperatures(apparent apparentTemperature: Float, current currentTemperature: Float) -> Self {
            let difference = currentTemperature.rounded(.toNearestOrEven) - apparentTemperature.rounded(.toNearestOrEven)
            if difference == 0 {
                return .equal
            } else if difference < 0 {
                return .warmer(abs(difference))
            } else {
                return .colder(difference)
            }
        }
    }
    
    override var title: String { NSLocalizedString("Feels like", comment: "") }
    
    // MARK: - Methods

    override func setupViews() {
        super.setupViews()
        addSubview(temperatureLabel)
        addSubview(descriptionLabel)

        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.85)
            make.bottom.equalToSuperview().offset(-5)
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom)
        }
    }

    func configure(withApparent apparentTemperature: Float, current currentTemperature: Float) {
        let apparentTemperatureType = ApparentTemperatureType.compareTemperatures(apparent: apparentTemperature,
                                                                               current: currentTemperature)
        let descriptionText = apparentTemperatureType.localizedDescription

        temperatureLabel.setTemperature(apparentTemperature)
        descriptionLabel.setAttributedTextWithShadow(descriptionText)
    }
    
    // MARK: - Views
    
    private let temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .white.withAlphaComponent(0.5)
        
        return label
    }()
}
