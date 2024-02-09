//
//  ContainerView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

class ContainerView: UIView, StyledContainer {
    
    var containerName: String { "" }

    private var blurEffectView = UIVisualEffectView.configureBlur(style: .systemChromeMaterialDark, withAlpha: 0.2)

    init() {
        super.init(frame: .zero)
        setViews()
        setContainerName(containerName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.layer.cornerRadius = 15
    }
    
    func setViews() {
        addSubview(blurEffectView)
        addSubview(containerNameLabel)
        
        backgroundColor = .clear

        blurEffectView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        containerNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.2)
        }
    }

    func updateContainerStyle(with style: ContainerStyle) {
        blurEffectView.updateBlur(style: style.blurStyle, withAlpha: style.alpha)
    }
    
    private func setContainerName(_ text: String) {
        containerNameLabel.setAttributedTextWithShadow(text.uppercased())
    }

    private let containerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.7)
        return label
    }()
}
