//
//  GeoWeatherDetailTransitionAnimator.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 30.06.2023.
//

import UIKit

class GeoWeatherDetailTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let transitionAnimationDuration: TimeInterval = 0.05
    private let pathAnimationDuration: TimeInterval = 0.3
    private var initialPath: CGPath
    
    init(initialPath: CGPath) {
        self.initialPath = initialPath
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionAnimationDuration + pathAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        guard let fromViewSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: false) else { return }

        transitionContext.containerView.insertSubview(fromViewSnapshot, at: 0)
        transitionContext.containerView.addSubview(toView)

        let detailViewMask = CAShapeLayer(with: initialPath)
        toView.layer.mask = detailViewMask
        
        let finalPath = UIBezierPath(roundedRect: fromView.frame, cornerRadius: 15).cgPath

        let pathAnimation = configurePathAnimation(fromValue: initialPath, toValue: finalPath) { _ in
            toView.layer.mask = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        toView.alpha = 0.0
        UIView.animate(withDuration: transitionAnimationDuration) {
            toView.alpha = 1.0
        } completion: { _ in
            detailViewMask.path = finalPath
            detailViewMask.add(pathAnimation, forKey: "pathAnimation")
        }
    }

    private func configurePathAnimation(fromValue: CGPath?, toValue: CGPath?, completion: @escaping (Bool) -> Void) -> CABasicAnimation {
        let pathAnimation = CABasicAnimation(keyPath: "path")
        
        pathAnimation.fromValue = fromValue
        pathAnimation.toValue = toValue
        pathAnimation.duration = pathAnimationDuration
        pathAnimation.delegate = CALayerAnimationDelegate(animation: pathAnimation, completion: { flag in
            completion(flag)
        })
        
        return pathAnimation
    }
}
