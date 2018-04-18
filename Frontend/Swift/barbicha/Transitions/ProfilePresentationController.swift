//
//  ProfilePresentationController.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit

class ProfilePresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate{
    
    var dimmingView = UIView()
    
    override var shouldPresentInFullscreen: Bool {return true}
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        dimmingView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        dimmingView.alpha = 0
        
    }
    
    override func presentationTransitionWillBegin() {
        
        dimmingView.frame = self.containerView!.bounds
        dimmingView.alpha = 0
        containerView?.insertSubview(dimmingView, at: 0)
        
        
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.alpha = 1
            }, completion: nil)
        
        } else {dimmingView.alpha = 1}
        
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.dimmingView.alpha = 0
            }, completion: nil)
        
        } else { dimmingView.alpha = 0 }
        
    }
    
    override func containerViewWillLayoutSubviews() {
        
        if let containerBounds = containerView?.bounds {
            dimmingView.frame = containerBounds
            presentedView?.frame = containerBounds
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { return .overFullScreen}
    
}
