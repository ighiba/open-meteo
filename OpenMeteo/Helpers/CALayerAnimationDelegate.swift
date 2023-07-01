//
//  CALayerAnimationDelegate.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 30.06.2023.
//

import QuartzCore

class CALayerAnimationDelegate: NSObject, CAAnimationDelegate {
    
    private let keyPath: String?
    var completion: ((Bool) -> Void)?
    
    init(animation: CAAnimation, completion: ((Bool) -> Void)?) {
        if let animation = animation as? CABasicAnimation {
            self.keyPath = animation.keyPath
        } else {
            self.keyPath = nil
        }
        self.completion = completion
        
        super.init()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let anim = anim as? CABasicAnimation {
            guard anim.keyPath == self.keyPath else { return }
        }
        
        if let completion = self.completion {
            completion(flag)
            self.completion = nil
        }
    }
}
