//
//  GeoWeatherDetailTransitionAnimator.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 30.06.2023.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionAnimationDuration: TimeInterval {
        return 0.1
    }
    
    var pathAnimationDuration: TimeInterval {
        return 0.2
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionAnimationDuration + pathAnimationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // implement in child
    }
    
    fileprivate func configurePathAnimation(fromValue: CGPath?, toValue: CGPath?, completion: @escaping (Bool) -> Void) -> CABasicAnimation {
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

// MARK: - Push

class GeoWeatherDetailPushTransitionAnimator: TransitionAnimator {
    
    override var transitionAnimationDuration: TimeInterval {
        return 0.05
    }
    
    override var pathAnimationDuration: TimeInterval {
        return 0.3
    }

    private var initialPath: CGPath
    
    init(initialPath: CGPath) {
        self.initialPath = initialPath
        super.init()
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
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
            fromViewSnapshot.removeFromSuperview()
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
}

// MARK: - Pop

class GeoWeatherDetailPopTransitionAnimator: TransitionAnimator {
    
    override var transitionAnimationDuration: TimeInterval {
        return 0.2
    }
    
    override var pathAnimationDuration: TimeInterval {
        return 0.2
    }

    private var finalPath: CGPath
    
    init(finalPath: CGPath) {
        self.finalPath = finalPath
        super.init()
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            return
        }
        
        guard let fromViewSnapshot = fromViewController.view.snapshotView(afterScreenUpdates: false) else { return }

        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.addSubview(fromViewSnapshot)

        let initialPath = UIBezierPath(roundedRect: fromView.frame, cornerRadius: 15).cgPath
        let detailViewMask = CAShapeLayer(with: initialPath)
        fromViewSnapshot.layer.mask = detailViewMask

        let transitionAnimationDuration = self.transitionAnimationDuration
        
        let pathAnimation = configurePathAnimation(fromValue: initialPath, toValue: finalPath) { _ in
            fromViewSnapshot.alpha = 1.0
            
            UIView.animate(withDuration: transitionAnimationDuration) {
                fromViewSnapshot.alpha = 0.0
            } completion: { _ in
                fromViewSnapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        
        detailViewMask.path = self.finalPath
        detailViewMask.add(pathAnimation, forKey: "pathAnimation")
    }
}
