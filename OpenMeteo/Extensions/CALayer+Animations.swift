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
        removeOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        let initialPath = UIBezierPath(roundedRect: initialRect, cornerRadius: cornerRadius).cgPath
        let finalRect = initialRect.inset(by: insets)
        let finalPath = UIBezierPath(roundedRect: finalRect, cornerRadius: cornerRadius).cgPath

        let mask = CAShapeLayer(with: initialPath)
        self.mask = mask

        mask.animatePath(
            from: initialPath,
            to: finalPath,
            duration: duration,
            removeOnCompletion: removeOnCompletion,
            timingFunctionName: timingFunctionName,
            completion: completion
        )
    }
    
    func animateOpacity(
        from fromValue: CGFloat,
        to toValue: CGFloat,
        duration: TimeInterval,
        removeOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        opacity = Float(toValue)
        animate(
            from: fromValue as NSNumber,
            to: toValue as NSNumber,
            keyPath: "opacity",
            duration: duration,
            removeOnCompletion: removeOnCompletion,
            timingFunctionName: timingFunctionName,
            completion: completion
        )
    }
    
    func animateRotation(
        from fromValue: CGFloat,
        to toValue: CGFloat,
        duration: TimeInterval,
        removeOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: fromValue as NSNumber,
            to: toValue as NSNumber,
            keyPath: "transform.rotation",
            duration: duration,
            removeOnCompletion: removeOnCompletion,
            timingFunctionName: timingFunctionName,
            completion: completion
        )
    }
    
    func animate(
        from fromValue: NSNumber,
        to toValue: NSNumber,
        keyPath: String,
        duration: TimeInterval,
        removeOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        removeAnimation(forKey: keyPath)
        let animation = CABasicAnimation(keyPath: keyPath)
        
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.delegate = CALayerAnimationDelegate(animation: animation, completion: completion)
        
        add(animation, forKey: keyPath)
    }
}
