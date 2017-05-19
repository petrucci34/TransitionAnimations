//
//  FadeAnimationController.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/22/16.
//

import UIKit

/**
 AnimationController subclass that presents and dismisses a view controller with a fade animation.
 */
class FadeAnimationController: AnimationController {
    override func present(_ transitionContext: UIViewControllerContextTransitioning) {
        fade(transitionContext)
    }

    override func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        fade(transitionContext)
    }

    func fade(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
        }

        transitionContext.containerView.addSubview(toView)
        toView.alpha = 0
        toView.backgroundColor = UIColor.lightGray

        UIView.animate(withDuration: duration,
            animations: {
                toView.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
}
