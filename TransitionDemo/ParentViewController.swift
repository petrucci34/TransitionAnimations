//
//  ParentViewController.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/1/16.
//

import UIKit

class ParentViewController: UIViewController {
    var animationController: AnimationController?
    var embeddingNavigationController: UINavigationController?
    var dummyViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        dummyViewController = mainStoryboard.instantiateViewController(withIdentifier: "ChildViewController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func showChildViewController() {
        guard let viewController = dummyViewController else {
            return
        }

        embeddingNavigationController = UINavigationController(rootViewController: viewController)

        if let embeddingNavigationController = embeddingNavigationController {
            embeddingNavigationController.transitioningDelegate = animationController
            present(embeddingNavigationController, animated:true, completion:nil)
        }
    }

    @IBAction func didTapFirstButton(_ sender: UIButton) {
        animationController = ShrinkAnimationController()

        showChildViewController()
    }

    @IBAction func didTapSecondButton(_ sender: UIButton) {
        animationController = SidewaysAnimationController()
        (animationController as! SidewaysAnimationController).coveredScreenRatio = 0.9

        showChildViewController()
    }

    @IBAction func didTapThirdButton(_ sender: UIButton) {
        animationController = FadeAnimationController()

        showChildViewController()
    }

    @IBAction func didTapFourthButton(_ sender: UIButton) {
        animationController = PopAnimationController()

        showChildViewController()
    }

    @IBAction func didTapFifthButton(_ sender: UIButton) {
        animationController = CircularAnimationController()

        showChildViewController()
    }
}
