//
//  UIView+ScreenShotExtension.swift
//  TransitionDemo
//
//  Created by Korhan Bircan on 5/22/16.
//

import UIKit

extension UIView {
    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
