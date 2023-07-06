//
//  GeoWeatherDetailNetworkErrorView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 06.07.2023.
//

import UIKit

class GeoWeatherDetailNetworkErrorView: UIView {
    
    private let horizontalOffset: CGFloat = 10
    
    init() {
        super.init(frame: .zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        self.addSubview(noWifiIcon)
        self.addSubview(errorTitleLabel)
        self.addSubview(errorMessageLabel)
        
        noWifiIcon.snp.makeConstraints { make in
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
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func configure() {
        errorTitleLabel.text = NSLocalizedString("Network error", comment: "")
        errorMessageLabel.text = NSLocalizedString("We couldn't fetch the weather details due to a network problem.\nPlease make sure you have a stable internet connection and try again.", comment: "")
        
        errorTitleLabel.sizeToFit()
        errorMessageLabel.sizeToFit()
    }
    
    class func configureDefault() -> GeoWeatherDetailNetworkErrorView {
        let view = GeoWeatherDetailNetworkErrorView()
        view.configure()
        return view
    }
    
    // MARK: - Views
    
    private let noWifiIcon: UIImageView = {
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
