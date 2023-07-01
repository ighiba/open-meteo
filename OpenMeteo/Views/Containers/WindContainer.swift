//
//  WindContainer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit

final class WindContainer: ContainerView {

    override func setViews() {
        super.setViews()
        self.addSubview(windSpeedLabel)
        self.addSubview(windDirectionLabel)

        windSpeedLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY).offset(5)
        }
        
        windDirectionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY).offset(5)
        }
    }
    
    func configure(with wind: Wind) {
        let windDirectionDescriptionShort = WindDirection.obtain(by: wind.direction)?.localizedDescriptionShort ?? "--"
        
        self.setContainerName(NSLocalizedString("Wind", comment: ""))
        windSpeedLabel.setAttributedTextWithShadow(wind.localizedSpeedText)
        windDirectionLabel.setAttributedTextWithShadow(windDirectionDescriptionShort)
    }
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        
        return label
    }()
    
    private let windDirectionLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 30)
        label.textColor = .white
        
        return label
    }()
}
