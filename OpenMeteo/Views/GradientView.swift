//
//  GradientView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    var startColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }
    var endColor: UIColor = .white {
        didSet {
            updateGradientColors()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    init() {
        super.init(frame: .zero)
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = bounds
    }
    
    func setColors(start startColor: UIColor? = nil, end endColor: UIColor? = nil) {
        if let startColor = startColor {
            self.startColor = startColor
        }
        if let endColor = endColor {
            self.endColor = endColor
        }
    }
    
    func updateGradientColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
