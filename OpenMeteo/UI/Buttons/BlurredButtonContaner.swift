//
//  BlurredButtonContaner.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 01.07.2023.
//

import UIKit

final class BlurredButtonContainer: UIView {
    
    // MARK: - Properties

    private var blurViewIsHidden = false
    private let minAlpha: CGFloat = 0.0
    private let maxAlpha: CGFloat = 0.7
    
    private var blurEffectView: UIVisualEffectView!
    private let button: UIButton
    
    // MARK: - Init
    
    init(button: UIButton) {
        self.button = button
        super.init(frame: button.frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setupViews() {
        blurEffectView = configureBlurEffectView(frame: button.bounds, alpha: maxAlpha)
        
        addSubview(blurEffectView)
        addSubview(button)
    }
    
    private func configureBlurEffectView(frame: CGRect, alpha: CGFloat) -> UIVisualEffectView {
        let blurEffectView = UIVisualEffectView.configureBlur(style: .systemChromeMaterialDark, withAlpha: alpha)
        
        blurEffectView.frame = frame
        blurEffectView.layer.cornerRadius = blurEffectView.bounds.width / 2
        
        return blurEffectView
    }
    
    func setBlurAlpha(_ alpha: CGFloat) {
        blurEffectView.alpha = alpha
    }
    
    func updateBlurStyle(_ style: UIBlurEffect.Style) {
        blurEffectView.updateBlur(style: style)
    }
    
    // MARK: - Animations

    func transitionToHiddenBackground() {
        guard !blurViewIsHidden else { return }
        
        animateBlurViewAlpha(shouldHide: true)
    }
    
    func transitionToRevealedBackground() {
        guard blurViewIsHidden else { return }
        
        animateBlurViewAlpha(shouldHide: false)
    }
    
    private func animateBlurViewAlpha(shouldHide: Bool) {
        let newAlpha: CGFloat = shouldHide ? minAlpha : maxAlpha
        let options: UIView.AnimationOptions = [.beginFromCurrentState]
        
        UIView.transition(with: blurEffectView, duration: 0.3, options: options, animations: { [weak self] in
            self?.setBlurAlpha(newAlpha)
        }, completion: { [weak self] _ in
            self?.blurViewIsHidden = shouldHide
        })
    }
}
