//
//  ShrinkAnimationController.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/22/16.
//

import UIKit

/**
 AnimationController subclass that presents a view controller from bottom to a specified percentage of
 the top while shrinking the background view controller. Dismiss animation reverses the presentation
 animation.
 */
class ShrinkAnimationController: AnimationController {
    fileprivate var screenshotView: UIView?

    /// The ratio of the bottom section to the top section of the screen once the presentation animation
    /// completes. This is a number between 0 and 1. For exampele, 2.0/3.0 means the presented view
    /// controller will cover two thirds of the screen.
    var coveredScreenRatio: CGFloat = 2.0/3.0

    /// The ratio by which the background will shrink.
    var shrinkRatio: CGFloat = 0.9

    override func present(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let billPayView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }

        // Black background view.
        let blackBackgroundView = UIView(frame: billPayView.bounds)
        blackBackgroundView.backgroundColor = UIColor.black
        transitionContext.containerView.addSubview(blackBackgroundView)

        // Screenshot of bill pay view.
        let screenshotImageView = UIImageView(image: billPayView.screenshot())
        screenshotView = UIView(frame: billPayView.bounds)
        if let screenshotView = screenshotView {
            screenshotView.addSubview(screenshotImageView)
            transitionContext.containerView.addSubview(screenshotView)
        }

        // Move numPadView down by the height of the screen.
        numPadView.frame.origin.y += UIScreen.main.bounds.height
        transitionContext.containerView.addSubview(numPadView)
        transitionContext.containerView.backgroundColor = UIColor.clear

        UIView.animate(withDuration: duration,
            animations: {
                // Shrink the background view.
                if let screenshotView = self.screenshotView {
                    screenshotView.transform = CGAffineTransform(scaleX: self.shrinkRatio, y: self.shrinkRatio)
                }

                // Animate numPadView upwards.
                numPadView.frame.origin.y -= self.coveredScreenRatio * (UIScreen.main.bounds.height)
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }

    override func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }

        transitionContext.containerView.addSubview(numPadView)

        UIView.animate(withDuration: duration, animations: {
                // Scale up the background view.
                if let screenshotView = self.screenshotView {
                    screenshotView.transform = CGAffineTransform.identity
                }

                // Animate numPadView downwards and out of the screen bounds.
                numPadView.frame.origin.y += self.coveredScreenRatio * (UIScreen.main.bounds.height)
            }, completion: { _ in
                if let screenshotView = self.screenshotView {
                    screenshotView.removeFromSuperview()
                }

                transitionContext.completeTransition(true)
        })
    }
}
