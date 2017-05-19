//
//  Animator.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/17/16.
//

import UIKit

/**
 AnimationController subclass that presents and dismisses a view controller with a spring animation.
 */
class PopAnimationController: AnimationController {
    /// The amount of time (measured in seconds) to wait before beginning the animations.
    var delay = 0.0
    /// The damping ratio for the spring animation as it approaches its quiescent state.
    var damping: CGFloat = 0.4
    /// The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment.
    var initialSpringVelocity: CGFloat = 0.0

    override func present(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                return
        }

        numPadView.transform = CGAffineTransform(scaleX: CGFloat(0.01), y: CGFloat(0.01))
        transitionContext.containerView.addSubview(numPadView)

        UIView.animate(withDuration: duration,
            delay:delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: initialSpringVelocity,
            options: [],
            animations: {
            numPadView.transform = CGAffineTransform.identity
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }

    override func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let billPayView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }

        transitionContext.containerView.addSubview(billPayView)
        transitionContext.containerView.addSubview(numPadView)

        UIView.animate(withDuration: duration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: initialSpringVelocity,
            options: [],
            animations: {
                numPadView.transform = CGAffineTransform(scaleX: CGFloat(0.01), y: CGFloat(0.01))
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }
}
