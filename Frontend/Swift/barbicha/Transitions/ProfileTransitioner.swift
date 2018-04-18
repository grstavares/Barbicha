//
//  ProfileTransitioner.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class ProfileTransitioner: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromVC = transitionContext.viewController(forKey: .from)
        let fromView = transitionContext.view(forKey: .from)
        
        let toVC = transitionContext.viewController(forKey: .to)
        let toView = transitionContext.view(forKey: .to)
        
        let containerView = transitionContext.containerView
        
        if isPresenting {
            containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresenting ? toVC : fromVC
        let animatingView = animatingVC!.view
        
        let toFrame = transitionContext.finalFrame(for: animatingVC!)
        var dismissedFrame = toFrame
        dismissedFrame.origin.y += dismissedFrame.size.height
        
        let initialFrame = isPresenting ? dismissedFrame : toFrame
        let finalFrame = isPresenting ? toFrame : dismissedFrame
        
        animatingView?.frame = initialFrame
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 300, initialSpringVelocity: 5, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            
            animatingView?.frame = finalFrame
            if !self.isPresenting {animatingView?.alpha = 0}
            
        }) { (sucess: Bool) in
            
            if !self.isPresenting {fromView?.removeFromSuperview()}
            transitionContext.completeTransition(true)
            
        }
        
    }

}








