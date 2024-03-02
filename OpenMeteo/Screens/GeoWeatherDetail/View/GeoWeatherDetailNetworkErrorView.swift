//
//  GeoWeatherDetailNetworkErrorView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 06.07.2023.
//

import UIKit
import SnapKit

final class GeoWeatherDetailNetworkErrorView: UIView {
    
    private let horizontalOffset: CGFloat = 10
    private let errorMessageWidthMultiplier: CGFloat = 0.9
    
    private let errorTitle = NSLocalizedString("Network error", comment: "")
    private let errorMessage = NSLocalizedString("We couldn't fetch the weather details due to a network problem.\nPlease make sure you have a stable internet connection and try again.", comment: "")
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        self.setupViews()
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupViews() {
        addSubview(noWiFiIcon)
        addSubview(errorTitleLabel)
        addSubview(errorMessageLabel)
        
        noWiFiIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(errorTitleLabel.snp.top).offset(-horizontalOffset * 2)
        }
        
        errorTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-horizontalOffset * 5)
        }
        
        errorMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(errorTitleLabel.snp.bottom).offset(horizontalOffset)
            make.width.equalToSuperview().multipliedBy(errorMessageWidthMultiplier)
        }
    }
    
    private func setup() {
        errorTitleLabel.text = errorTitle
        errorMessageLabel.text = errorMessage
        
        errorTitleLabel.sizeToFit()
        errorMessageLabel.sizeToFit()
    }
    
    // MARK: - Views
    
    private let noWiFiIcon: UIImageView = {
        let symbolConfig = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 60))
        let image = UIImage(systemName: "wifi.slash", withConfiguration: symbolConfig)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
}
