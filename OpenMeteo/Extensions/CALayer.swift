//
//  CALayer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 05.07.2023.
//

import UIKit

extension CALayer {
    func animatePath(
        initialRect: CGRect,
        cornerRadius: CGFloat = 0,
        insets: UIEdgeInsets,
        duration: TimeInterval,
        isRemovedOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        let initialPath = UIBezierPath(roundedRect: initialRect, cornerRadius: cornerRadius).cgPath
        let finalRect = initialRect.inset(by: insets)
        let finalPath = UIBezierPath(roundedRect: finalRect, cornerRadius: cornerRadius).cgPath

        let mask = CAShapeLayer(with: initialPath)
        self.mask = mask

        mask.animatePath(from: initialPath, to: finalPath, duration: duration, timingFunctionName: timingFunctionName) { flag in
            completion?(flag)
        }
    }
    
    func animateOpacity(
        from fromValue: CGFloat,
        to toValue: CGFloat,
        duration: TimeInterval,
        isRemovedOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        removeAnimation(forKey: "opacity")
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue = toValue
        opacityAnimation.duration = duration
        opacityAnimation.isRemovedOnCompletion = isRemovedOnCompletion
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        opacityAnimation.delegate = CALayerAnimationDelegate(animation: opacityAnimation, completion: { flag in
            completion?(flag)
        })
        
        opacity = Float(toValue)
        add(opacityAnimation, forKey: "opacityAnimation")
    }
    
    func animateRotation(
        from fromValue: CGFloat,
        to toValue: CGFloat,
        duration: TimeInterval,
        isRemovedOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        removeAnimation(forKey: "transform.rotation")
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        
        rotationAnimation.fromValue = fromValue
        rotationAnimation.toValue = toValue
        rotationAnimation.duration = duration
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        rotationAnimation.isRemovedOnCompletion = isRemovedOnCompletion
        rotationAnimation.delegate = CALayerAnimationDelegate(animation: rotationAnimation, completion: { flag in
            completion?(flag)
        })
        
        add(rotationAnimation, forKey: "rotationAnimation")
    }
}
