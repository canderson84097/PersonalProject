//
//  CustomView.swift
//  MediaSearch
//
//  Created by Chris Anderson on 12/26/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

extension UIView {

   func addCornerRadius(_ radius: CGFloat = 4) {
       layer.cornerRadius = radius
   }
    
    func itemCornerRadius(radius: CGFloat = 8) {
        layer.cornerRadius = frame.height / radius
    }
   
   func addAccentBorder(width: CGFloat = 1, color: UIColor = UIColor.cyan) {
       layer.borderWidth = width
       layer.borderColor = color.cgColor
   }
   
   func rotate(by radians: CGFloat = (-CGFloat.pi / 2)) {
       self.transform = CGAffineTransform(rotationAngle: radians)
   }
}

extension UIColor {
    static let cyan = UIColor(named: "cyan")!
    static let mediumGreen = UIColor(named: "mediumGreen")!
    static let yellow = UIColor(named: "yellow")!
    static let offYellow = UIColor(named: "offYellow")!
    static let orange = UIColor(named: "orange")!
    static let red = UIColor(named: "red")!
    static let limeGreen = UIColor(named: "limeGreen")!
    static let aquamarine = UIColor(named: "aquamarine")!
    static let unclickedText = UIColor(named: "unclickedText")!
    static let spaceGrey = UIColor(named: "spaceGrey")!
}

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)

        present(viewControllerToPresent, animated: false)
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)

        dismiss(animated: false)
    }
}
