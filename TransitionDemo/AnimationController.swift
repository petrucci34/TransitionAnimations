//
//  AnimationController.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/22/16.
//

import UIKit

/**
 The base class that controls how a view controller is presented or dismissed. The details of how these
 animations are implemented are left to the subclasses. This base class takes care of the boilerplate
 code around transitioning delegation so that the subclasses can focus on the mechanics of the animations.
 */
class AnimationController: NSObject {
    /// Animation duration in seconds.
    var duration: TimeInterval

    fileprivate var isPresenting = true
    fileprivate let screenHeight = max(UIScreen.main.bounds.size.height, UIScreen.main.bounds.size.width)

    /**
     Default initializer.
     - Parameters:
        - duration: Animation duration in seconds.
     */
    required init(duration: TimeInterval? = 1.0) {
        self.duration = duration!

        super.init()
    }

    /**
     To be overridden by subclasses. This is where view controller presentation animation takes place.
     - Parameters:
        - transitionContext: Contextual information for transition animations between view controllers.
     */
    func present(_ transitionContext: UIViewControllerContextTransitioning) {
        assertionFailure("Subclasses must implement this method.")
    }

    /**
     To be overridden by subclasses. This is where view controller dismiss animation takes place.
     - Parameters:
        - transitionContext: Contextual information for transition animations between view controllers.
     */
    func dismiss(_ transitionContext: UIViewControllerContextTransitioning) {
        assertionFailure("Subclasses must implement this method.")
    }
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.isPresenting {
            present(transitionContext)
        } else {
            dismiss(transitionContext)
        }
    }
}

extension AnimationController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
}
