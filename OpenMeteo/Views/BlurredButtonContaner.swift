//
//  BlurredButtonContaner.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 01.07.2023.
//

import UIKit

class BlurredButtonContainer: UIView {

    private var blurViewIsHidden = false
    private let minAlpha: CGFloat = 0.0
    private let maxAlpha: CGFloat = 0.7
    
    var button: UIButton
    
    init(button: UIButton) {
        self.button = button
        super.init(frame: button.frame)

        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        self.addSubview(blurEffectView)
        self.addSubview(button)
    }
    
    // MARK: - Views
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView.obtainBlur(style: .systemChromeMaterialDark, withAlpha: maxAlpha)
        
        blurEffectView.frame = button.bounds
        blurEffectView.layer.cornerRadius = blurEffectView.bounds.width / 2
        
        return blurEffectView
    }()
    
    func setBlurAlpha(_ alpha: CGFloat) {
        guard alpha != blurEffectView.alpha else { return }
        blurEffectView.alpha = alpha
    }
    
    func updateBlurStyle(_ style: UIBlurEffect.Style) {
        blurEffectView.updateBlur(style: style, withAlpha: blurEffectView.alpha)
    }
    
    // MARK: - Animations

    func animateHideButtonBackground() {
        guard !blurViewIsHidden else { return }
        animateBlurViewAlpha(shouldHide: true)
    }
    
    func animateShowButtonBackground() {
        guard blurViewIsHidden else { return }
        animateBlurViewAlpha(shouldHide: false)
    }
    
    private func animateBlurViewAlpha(shouldHide: Bool) {
        let alpha: CGFloat = shouldHide ? minAlpha : maxAlpha
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState]) { [weak self] in
            self?.setBlurAlpha(alpha)
        } completion: { [weak self]_ in
            self?.blurViewIsHidden = shouldHide
        }
    }
}
