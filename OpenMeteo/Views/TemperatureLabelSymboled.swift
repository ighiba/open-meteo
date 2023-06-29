//
//  TemperatureLabelSymboled.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit
import SnapKit

class TemperatureLabelSymboled: UIView {
    
    private var symbolName: String

    init(symbolName: String) {
        self.symbolName = symbolName
        super.init(frame: .zero)
        setViews()
    }
    
    override init(frame: CGRect) {
        self.symbolName = ""
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func setViews() {
        self.addSubview(symbolView)
        self.addSubview(temperatureLabel)
        
        symbolView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(11)
            make.height.equalTo(22)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(symbolView.snp.trailing).offset(3)
        }
    }
    
    func makeConstraints(superview: UIView, toLeading: Bool) {
        self.snp.makeConstraints { make in
            let sideConstraint = toLeading ? make.leading : make.trailing
            sideConstraint.equalTo(superview)
            make.centerY.equalTo(superview)
            make.top.equalTo(superview)
            make.bottom.equalTo(superview)
            make.width.equalTo(superview).multipliedBy(0.5)
        }
    }
    
    func setTemperature(_ temperature: Float) {
        temperatureLabel.text = String(format: "%.0f°", temperature)
        temperatureLabel.sizeToFit()
    }
    
    // MARK: - Views
    
    lazy var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: symbolName)
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
}
