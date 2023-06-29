//
//  TemperatureLabelSymboled.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 29.06.2023.
//

import UIKit
import SnapKit

class TemperatureLabelSymboled: UIView {
    
    private var symbolName: String = ""

    private let symbolWidth: CGFloat = 11
    private let symbolInset: CGFloat = 3
    private let temperatureLabelWidth: CGFloat = 42

    init(symbolName: String) {
        self.symbolName = symbolName
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
        self.addSubview(symbolView)
        self.addSubview(temperatureLabel)
        
        self.temperatureLabel.textAlignment = .left
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
    
    func setTemperature(_ temperature: Float) {
        temperatureLabel.text = String(format: "%.0f°", temperature)
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
        return label
    }()
}
