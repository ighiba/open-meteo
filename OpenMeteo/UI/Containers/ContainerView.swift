//
//  ContainerView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 02.07.2023.
//

import UIKit
import SnapKit

class ContainerView: UIView, StyledContainer {
    
    var title: String { "" }

    private let blurEffectView = UIVisualEffectView.configureBlur(style: .systemChromeMaterialDark, withAlpha: 0.2)
    
    // MARK: - Init

    init() {
        super.init(frame: .zero)
        self.setupViews()
        self.setContainerTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blurEffectView.layer.cornerRadius = 15
    }
    
    func setupViews() {
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
    
    private func setContainerTitle(_ text: String) {
        containerNameLabel.setAttributedTextWithShadow(text.uppercased())
    }

    func updateContainerStyle(with style: ContainerStyle) {
        blurEffectView.updateBlur(style: style.blurStyle, withAlpha: style.alpha)
    }
    
    // MARK: - Views

    private let containerNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white.withAlphaComponent(0.7)
        
        return label
    }()
}
