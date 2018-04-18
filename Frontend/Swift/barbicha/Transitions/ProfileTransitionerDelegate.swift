//
//  ProfileTransitionerDelegate.swift
//  Barbicha
//
//  Created by Gustavo Tavares on 17/04/2018.
//  Copyright © 2018 Gustavo Tavares. All rights reserved.
//

import UIKit
class ProfileTransitionerDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = ProfilePresentationController(presentedViewController: presented, presenting: presenting)
        return presentation
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = ProfileTransitioner()
        animationController.isPresenting = true
        return animationController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = ProfileTransitioner()
        animationController.isPresenting = false
        return animationController
        
    }
    
    
}
