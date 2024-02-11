//
//  GradientView.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 28.06.2023.
//

import UIKit

final class GradientView: UIView {
    
    private let gradientLayer = CAGradientLayer()
    
    private(set) var startColor: UIColor = .white
    private(set) var endColor: UIColor = .white
    
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    // MARK: - Init
    
    init(startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
        super.init(frame: .zero)
        self.setupGradient(startPoint: startPoint, endPoint: endPoint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = bounds
    }
    
    private func setupGradient(startPoint: CGPoint, endPoint: CGPoint) {
        layer.addSublayer(gradientLayer)
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
    
    func setColors(start newStartColor: UIColor, end newEndColor: UIColor) {
        startColor = newStartColor
        endColor = newEndColor
        
        updateGradientColors()
    }
    
    private func updateGradientColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}
