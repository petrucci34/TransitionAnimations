//
//  CircularAnimationController.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/22/16.
//

import UIKit
import Darwin

struct Circle {
    var bounds: CGRect
    var path: CGPath
}

/**
 AnimationController subclass that presents a view controller with a circle animation that starts
 with a 1pt radius in the center of the screen and expands to fill the screen. The dismiss animation
 is a bit different for fun. It shrinks the view controller towards the center of the screen until it
 disappears.
 */
class CircularAnimationController: AnimationController {
    fileprivate var screenshotView: UIView?
    fileprivate var darkLayer: UIView?

    // Small circle has diameter 1 and is in the middle of the screen.
    fileprivate func smallCircle(_ transitionContext: UIViewControllerContextTransitioning) -> Circle? {
        let containerBounds = transitionContext.containerView.bounds
        let centerX = containerBounds.midX
        let centerY = containerBounds.midY
        let bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
        let path = UIBezierPath(ovalIn: CGRect(x: centerX, y: centerY, width: 1, height: 1)).cgPath

        return Circle(bounds: bounds, path: path)
    }

    // Big circle is in the middle of the screen and has a diameter twice the height of the screen.
    fileprivate func bigCircle(_ transitionContext: UIViewControllerContextTransitioning) -> Circle? {
        let containerBounds = transitionContext.containerView.bounds
        let containerHeight = containerBounds.height
        let centerX = containerBounds.midX
        let centerY = containerBounds.midY
        let bounds = CGRect(x: 0, y: 0, width: 4*containerHeight, height: 4*containerHeight)
        let path = UIBezierPath(ovalIn: CGRect(x: centerX, y: centerY, width: 4*containerHeight, height: 4*containerHeight)).cgPath

        return Circle(bounds: bounds, path: path)
    }

    override func present(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let billPayView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let smallCircle = smallCircle(transitionContext),
            let bigCircle = bigCircle(transitionContext) else {
                return
        }

        // Prevents the navigation bar background from being black.
        numPadView.backgroundColor = UIColor.lightGray

        // Screenshot of bill pay view.
        let screenshotImageView = UIImageView(image: billPayView.screenshot())
        screenshotView = UIView(frame: billPayView.bounds)
        if let screenshotView = screenshotView {
            screenshotView.addSubview(screenshotImageView)
            transitionContext.containerView.addSubview(screenshotView)
        }

        // Darken background view.
        darkLayer = UIView(frame: transitionContext.containerView.bounds)
        if let darkLayer = darkLayer {
            darkLayer.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            transitionContext.containerView.addSubview(darkLayer)
            darkLayer.alpha = 0
        }

        // Animate darkening background.
        UIView.animate(withDuration: 0.5, animations: {
            if let darkLayer = self.darkLayer {
                darkLayer.alpha = 1
            }
        }) 

        // Add numPad view but mask it with a growing circle.
        transitionContext.containerView.addSubview(numPadView)

        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = smallCircle.path
        pathAnimation.toValue = bigCircle.path

        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: smallCircle.bounds)
        boundsAnimation.toValue = NSValue(cgRect: bigCircle.bounds)

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [pathAnimation, boundsAnimation]
        animationGroup.duration = duration

        // Set the numPad view's layer mask to be a circle shape.
        let circleShapeLayer = CAShapeLayer()
        circleShapeLayer.path = smallCircle.path
        circleShapeLayer.bounds = smallCircle.bounds
        numPadView.layer.mask = circleShapeLayer

        CATransaction.begin()
        circleShapeLayer.path = bigCircle.path
        circleShapeLayer.bounds = bigCircle.bounds
        circleShapeLayer.add(animationGroup, forKey: nil)
        CATransaction.setCompletionBlock {
            transitionContext.completeTransition(true)
        }
        CATransaction.commit()
    }

    override func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let numPadView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }

        // Fade out the dark background.
        UIView.animate(withDuration: duration, animations: {
            if let darkLayer = self.darkLayer {
                darkLayer.alpha = 0
            }
        }) 

        transitionContext.containerView.addSubview(numPadView)

        UIView.animate(withDuration: duration, animations: {
            numPadView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }, completion: { (_) -> Void  in
                transitionContext.completeTransition(true)
        }) 
    }
}
