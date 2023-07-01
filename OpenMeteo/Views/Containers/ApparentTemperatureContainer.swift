//
//  ApparentTemperatureContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit

final class ApparentTemperatureContainer: ContainerView {
    
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
            var difference = abs(currentTemperature - apparentTemperature)
            difference = difference > 0.5 ? difference : 1
            if String(format: "%.0f", apparentTemperature) == String(format: "%.0f", currentTemperature) {
                return .equal
            } else if apparentTemperature > currentTemperature {
                return .warmer(difference)
            } else {
                return .colder(difference)
            }
        }
    }

    override func setViews() {
        super.setViews()
        self.addSubview(temperatureLabel)
        self.addSubview(descriptionLabel)

        temperatureLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(temperatureLabel.snp.bottom).offset(5)
        }
    }

    func configure(withApparent apparentTemperature: Float, current currentTemperature: Float) {
        let containerName = NSLocalizedString("Feels like", comment: "")
        let apparentTemperatureType = ApparentTemperatureType.compareTemperatures(apparent: apparentTemperature,
                                                                               current: currentTemperature)
        let descriptionText = apparentTemperatureType.localizedDescription
        
        self.setContainerName(containerName)
        temperatureLabel.setTemperature(apparentTemperature)
        descriptionLabel.setAttributedTextWithShadow(descriptionText)
    }
    
    private let temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = .white
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white.withAlphaComponent(0.5)
        
        return label
    }()
}
