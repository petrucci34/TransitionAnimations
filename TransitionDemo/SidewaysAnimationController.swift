//
//  SidewaysAnimationController.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/24/16.
//

import UIKit

/**
 AnimationController subclass that presents a view controller from the side of the screen
 a specified percentage of the right to the left. The view controller in the background is shrunk while
 the animation is taking place.
 */
class SidewaysAnimationController: AnimationController {
    fileprivate var screenshotView: UIView?
    fileprivate var darkLayer: UIView?

    /// This flag determins the direction of the presentation animation.
    var rightToLeft = true

    /// The ratio of the presnetd section to the background section of the screen once the presentation animation
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

        // Darken bill pay view.
        darkLayer = UIView(frame: transitionContext.containerView.bounds)
        if let darkLayer = darkLayer {
            darkLayer.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            transitionContext.containerView.addSubview(darkLayer)
            darkLayer.alpha = 0
        }

        // Move numPadView in the desired direction.
        numPadView.frame.origin.x += (self.rightToLeft ? 1 : -1) * UIScreen.main.bounds.width
        transitionContext.containerView.addSubview(numPadView)
        transitionContext.containerView.backgroundColor = UIColor.clear

        UIView.animate(withDuration: duration,
            animations: {
                // Animate darkening background.
                if let darkLayer = self.darkLayer {
                    darkLayer.alpha = 1
                }

                // Shrink the background view.
                if let screenshotView = self.screenshotView {
                    screenshotView.transform = CGAffineTransform(scaleX: self.shrinkRatio, y: self.shrinkRatio)
                }

                // Animate numPadView to the opposite side.
                numPadView.frame.origin.x += (self.rightToLeft ? -1 : 1) * self.coveredScreenRatio * (UIScreen.main.bounds.width)
            }, completion: { _ in
                transitionContext.completeTransition(true)
        })
    }

    override func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }

        transitionContext.containerView.addSubview(numPadView)

        UIView.animate(withDuration: duration,
            animations: {
                // Fade out the dark layer above the bill pay view.
                if let darkLayer = self.darkLayer {
                    darkLayer.alpha = 0
                }

                // Scale up the background view.
                if let screenshotView = self.screenshotView {
                    screenshotView.transform = CGAffineTransform.identity
                }

                // Animate numPadView to the opposite side and out of the screen bounds.
                numPadView.frame.origin.x += (self.rightToLeft ? 1 : -1) * self.coveredScreenRatio * (UIScreen.main.bounds.width)
            }, completion: { _ in
                if let screenshotView = self.screenshotView {
                    screenshotView.removeFromSuperview()
                }
                
                transitionContext.completeTransition(true)
        })
    }
}
