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
    
    fileprivate func captureSnapshot(_ viewcontroller: UIViewController, afterScreenUpdates: Bool) -> UIImageView? {
        let image = captureSnapshotImage(viewcontroller, afterScreenUpdates: afterScreenUpdates)
        return UIImageView(image: image)
    }
    
    fileprivate func captureSnapshotImage(_ viewcontroller: UIViewController, afterScreenUpdates: Bool) -> UIImage? {
        guard let navigationController = viewcontroller.navigationController else { return nil }
        let renderer = UIGraphicsImageRenderer(size: navigationController.view.bounds.size)
        let snapshot = renderer.image { context in
            navigationController.view.drawHierarchy(in: navigationController.view.bounds, afterScreenUpdates: afterScreenUpdates)
        }
        return snapshot
    }
}

// MARK: - Push

class GeoWeatherDetailPushTransitionAnimator: TransitionAnimator {
    
    override var transitionAnimationDuration: TimeInterval {
        return 0.05
    }
    
    override var pathAnimationDuration: TimeInterval {
        return 0.2
    }

    private var initialPath: CGPath
    
    init(initialPath: CGPath) {
        self.initialPath = initialPath
        super.init()
    }

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        guard let fromViewSnapshot = captureSnapshot(fromViewController, afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }

        configureNavigationBarPush(for: toViewController)

        transitionContext.containerView.addSubview(fromViewSnapshot)
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
    
    private func configureNavigationBarPush(for viewController: UIViewController) {
        viewController.navigationController?.setNavigationBarHidden(true, animated: false)
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
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
              let toViewController = transitionContext.viewController(forKey: .to),
              let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
              
        else {
            transitionContext.completeTransition(false)
            return
        }

        configureNavigationBarPop(for: fromViewController)
        
        guard let fromViewSnapshot = captureSnapshot(fromViewController, afterScreenUpdates: false) else {
            transitionContext.completeTransition(false)
            return
        }

        fromViewSnapshot.frame = convertNavigationBarToSuperview(
            for: fromViewSnapshot,
            to: fromViewController.view,
            navBarFrame: fromViewController.navigationController?.navigationBar.frame ?? .zero
        )
        
        toViewController.navigationController?.navigationBar.addSubview(fromViewSnapshot)
        transitionContext.containerView.addSubview(toView)

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
    
    private func configureNavigationBarPop(for viewController: UIViewController) {
        let navBarAppearance = UINavigationBarAppearance.configureDefaultBackgroundAppearance()
        let scrollEdgeAppearance = UINavigationBarAppearance.configureTransparentBackgroundAppearance()
        
        viewController.navigationController?.navigationBar.standardAppearance = navBarAppearance
        viewController.navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
        viewController.navigationController?.setNavigationBarHidden(true, animated: false)
        viewController.navigationController?.setNavigationBarHidden(false, animated: false)
        
        viewController.navigationController?.navigationBar.tintColor = nil
    }
    
    private func convertNavigationBarToSuperview(for view: UIView, to superview: UIView, navBarFrame: CGRect) -> CGRect {
        let verticalOffset = -superview.convert(navBarFrame, to: superview).origin.y
        return CGRect(x: 0, y: verticalOffset, width: view.frame.width, height: view.frame.height)
    }
}
