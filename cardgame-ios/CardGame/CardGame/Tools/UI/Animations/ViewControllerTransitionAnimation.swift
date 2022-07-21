//
//  ViewControllerTransitionAnimation.swift
//  CardGame
//
//  Created by Davorin on 01/09/16.
//  Copyright © 2016 DavorinMadaric. All rights reserved.
//

import UIKit

class ViewControllerTransitionAnimation: NSObject, UIViewControllerTransitioningDelegate {
    let presentationAnimator = TransitionPresentationAnimator()
    let dismissalAnimator = TransitionDismissalAnimator()

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimator
    }
    
    
}

class TransitionPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        // take a snapshot of the detail ViewController so we can do whatever with it (cause it's only a view), and don't have to care about breaking constraints
        let snapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        snapshotView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        snapshotView?.center = fromViewController.view.center
        containerView.addSubview(snapshotView!)
        
        // hide the detail view until the snapshot is being animated
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 20.0, options: [],
                                   animations: { () -> Void in
                                    snapshotView?.transform = CGAffineTransform.identity
            }, completion: { (finished) -> Void in
                snapshotView?.removeFromSuperview()
                toViewController.view.alpha = 1.0
                transitionContext.completeTransition(finished)
        })
    }
    
}

class TransitionDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        snapshotView?.center = toViewController.view.center
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.alpha = 0.0
        
        let toViewControllerSnapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        containerView.insertSubview(toViewControllerSnapshotView!, belowSubview: snapshotView!)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            snapshotView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            snapshotView?.alpha = 0.0
        }, completion: { (finished) -> Void in
            toViewControllerSnapshotView?.removeFromSuperview()
            snapshotView?.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }) 
    }
    
}
