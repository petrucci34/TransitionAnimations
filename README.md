# UIViewController Transition Animations
This is a sample project that demonstrates the UIViewController custom transition animations that were introduced in iOS 7.

The project contains 6 animations out-of-the-box and provides a framework to create any other custom animation.

In order to present a view controller using a custom transition animation, the presented view controller needs to be embedded in a navigation controller. The next step is to implement the [transitioningDelegate](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/CustomizingtheTransitionAnimations.html#//apple_ref/doc/uid/TP40007457-CH16-SW15). This is where the built-in animation controllers come into play eg.:

```
embeddingNavigationController = UINavigationController(rootViewController: viewController)

if let embeddingNavigationController = embeddingNavigationController {
    embeddingNavigationController.transitioningDelegate = animationController
    present(embeddingNavigationController, animated:true, completion:nil)
}
```

Here, the `animationController` can be one of the built-in classes such as:

Shrink Animation which presents a view controller from bottom to a specified percentage of
 the top while shrinking the background view controller eg.:
```
animationController = ShrinkAnimationController()
```

Sideways Animation which presents a view controller from the side of the screen
 a specified percentage of the right to the left eg.:
```
animationController = SidewaysAnimationController()
```

Fade Animation which presents and dismisses a view controller with a fade animation eg.:
```
animationController = FadeAnimationController()
```

Pop Animation which presents and dismisses a view controller with a spring animation eg.:
```
animationController = PopAnimationController()
```

Circular Animation which presents a view controller with a circle animation that starts
 with a 1pt radius in the center of the screen and expands to fill the screen eg.:
```
animationController = CircularAnimationController()
```

Here's how these animations look:

<img src="https://raw.githubusercontent.com/petrucci34/TransitionAnimations/master/transitions.gif">

A while back I gave a presentation about this topic at Capital One internal conference and the slides can be found [here](https://github.com/petrucci34/TransitionAnimations/blob/master/Slides.pdf).