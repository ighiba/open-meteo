//
//  TemperatureLabelSymboled.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit
import SnapKit

class TemperatureLabelSymboled: UIView {
    
    // MARK: - Properties
    
    private var symbolName: String = ""
    private var temperatureFontSize: CGFloat = 20

    private let symbolInset: CGFloat = 3
    private var symbolWidth: CGFloat {
        return temperatureFontSize * 0.58
    }
    
    private var temperatureLabelWidth: CGFloat {
        return temperatureFontSize * 2.1
    }
    
    var prefferedWidth: CGFloat {
        return symbolWidth + temperatureLabelWidth + (symbolInset * 2) + (symbolWidth / 2)
    }
    
    // MARK: - Init
    
    init(symbolName: String, temperatureFontSize: CGFloat) {
        self.symbolName = symbolName
        self.temperatureFontSize = temperatureFontSize
        super.init(frame: .zero)
        setViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func setViews() {
        addSubview(symbolView)
        addSubview(temperatureLabel)
        
        temperatureLabel.textAlignment = .left
        temperatureLabel.font = UIFont.systemFont(ofSize: temperatureFontSize, weight: .light)
    }
    
    func makeConstraints(superview: UIView, toLeading: Bool) {
        symbolView.snp.makeConstraints { make in
            if toLeading {
                make.trailing.equalTo(temperatureLabel.snp.leading).inset(-symbolInset)
            } else {
                make.leading.equalToSuperview().offset(symbolWidth / 2)
            }
            make.centerY.equalToSuperview()
            make.width.equalTo(symbolWidth)
            make.height.equalTo(symbolWidth * 2)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            if toLeading {
                make.trailing.equalToSuperview()
            } else {
                make.leading.equalTo(symbolView.snp.trailing).offset(symbolInset)
            }
            make.centerY.equalToSuperview()
            make.width.equalTo(temperatureLabelWidth)
            make.height.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            let sideConstraint = toLeading ? make.leading : make.trailing
            sideConstraint.equalTo(superview)
            make.centerY.equalTo(superview)
            make.top.equalTo(superview)
            make.bottom.equalTo(superview)
            make.width.equalTo(superview).multipliedBy(0.5)
        }
    }
    
    func setColors(_ color: UIColor) {
        temperatureLabel.textColor = color
        symbolView.tintColor = color
    }
    
    func setTemperature(_ temperature: Float) {
        temperatureLabel.setTemperature(temperature)
    }
    
    // MARK: - Views
    
    lazy var symbolView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: symbolName)
        imageView.tintColor = .label
        return imageView
    }()

    lazy var temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: temperatureFontSize)
        return label
    }()
}
