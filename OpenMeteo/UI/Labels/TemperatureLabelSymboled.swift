//
//  TemperatureLabelSymboled.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit
import SnapKit

final class TemperatureLabelSymboled: UIView {
    
    // MARK: - Properties
    
    private let symbolName: String
    private let temperatureFontSize: CGFloat

    private let symbolInset: CGFloat = 3
    private var symbolWidth: CGFloat { temperatureFontSize * 0.58 }
    private var symbolHeight: CGFloat { symbolWidth * 2 }
    private let widthMultiplier: CGFloat = 0.5
    
    private var temperatureLabelWidth: CGFloat { temperatureFontSize * 2.1 }
    
    var prefferedWidth: CGFloat { symbolWidth + temperatureLabelWidth + (symbolInset * 2) + (symbolWidth / 2) }
    
    // MARK: - Init
    
    init(symbolName: String, temperatureFontSize: CGFloat) {
        self.symbolName = symbolName
        self.temperatureFontSize = temperatureFontSize
        super.init(frame: .zero)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupViews() {
        addSubview(symbolView)
        addSubview(temperatureLabel)
    }
    
    func setupConstraints(superview: UIView, toLeading: Bool) {
        symbolView.snp.makeConstraints { make in
            if toLeading {
                make.trailing.equalTo(temperatureLabel.snp.leading).inset(-symbolInset)
            } else {
                make.leading.equalToSuperview().offset(symbolWidth / 2)
            }
            make.centerY.equalToSuperview()
            make.width.equalTo(symbolWidth)
            make.height.equalTo(symbolHeight)
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
            make.width.equalTo(superview).multipliedBy(widthMultiplier)
        }
    }
    
    func setColor(_ color: UIColor) {
        temperatureLabel.textColor = color
        symbolView.tintColor = color
    }
    
    func setTemperature(_ temperature: Float) {
        temperatureLabel.setTemperature(temperature)
    }
    
    // MARK: - Views
    
    lazy var symbolView: UIImageView = {
        let image = UIImage(systemName: symbolName)
        let imageView = UIImageView(image: image)
        
        imageView.tintColor = .label
        
        return imageView
    }()

    lazy var temperatureLabel: TemperatureLabel = {
        let label = TemperatureLabel()
        
        label.text = "0"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: temperatureFontSize, weight: .light)
        
        return label
    }()
}
