//
//  CAShapeLayer.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 30.06.2023.
//

import QuartzCore

extension CAShapeLayer {
    convenience init(with path: CGPath?) {
        self.init()
        self.path = path
    }
    
    func animatePath(
        from fromValue: CGPath,
        to toValue: CGPath,
        duration: TimeInterval,
        removeOnCompletion: Bool = false,
        timingFunctionName: CAMediaTimingFunctionName = .easeInEaseOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        removeAnimation(forKey: "path")
        let pathAnimation = CABasicAnimation(keyPath: "path")
        
        pathAnimation.fromValue = fromValue
        pathAnimation.toValue = toValue
        pathAnimation.duration = duration
        pathAnimation.isRemovedOnCompletion = removeOnCompletion
        pathAnimation.timingFunction = CAMediaTimingFunction(name: timingFunctionName)
        pathAnimation.delegate = CALayerAnimationDelegate(animation: pathAnimation, completion: completion)
        
        path = toValue
        add(pathAnimation, forKey: "path")
    }
}
