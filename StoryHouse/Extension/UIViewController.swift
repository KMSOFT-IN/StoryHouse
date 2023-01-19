//
//  UIViewController.swift
//  PaintInTheCity
//
//  Created by KMSOFT on 04/09/20.
//  Copyright © 2020 KMSOFT. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureChildViewController(childController: UIViewController, onView: UIView) {
        onView.removeAllSubviews()
        self.addChild(childController)
        onView.addSubview(childController.view)
        constrainViewEqual(holderView: onView, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    func configureChildViewController1(childController: UIViewController, onView: UIView) {
        //  onView.removeAllSubviews()
        self.addChild(childController)
        onView.addSubview(childController.view)
        constrainViewEqual(holderView: onView, view: childController.view)
        childController.didMove(toParent: self)
        childController.willMove(toParent: self)
    }
    
    func constrainViewEqual(holderView: UIView, view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        //pin 100 points from the top of the super
        let pinTop = NSLayoutConstraint(item: view,
                                        attribute: .top,
                                        relatedBy: .equal,
                                        toItem: holderView,
                                        attribute: .top,
                                        multiplier: 1.0,
                                        constant: 0)
        let pinBottom = NSLayoutConstraint(item: view,
                                           attribute: .bottom,
                                           relatedBy: .equal,
                                           toItem: holderView,
                                           attribute: .bottom,
                                           multiplier: 1.0,
                                           constant: 0)
        let pinLeft = NSLayoutConstraint(item: view,
                                         attribute: .left,
                                         relatedBy: .equal,
                                         toItem: holderView,
                                         attribute: .left,
                                         multiplier: 1.0,
                                         constant: 0)
        let pinRight = NSLayoutConstraint(item: view,
                                          attribute: .right,
                                          relatedBy: .equal,
                                          toItem: holderView,
                                          attribute: .right,
                                          multiplier: 1.0,
                                          constant: 0)
        holderView.addConstraints([pinTop, pinBottom, pinLeft, pinRight])
    }
    
    
    func alert(message: String, title: String? = APPNAME) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okString = "Ok"
            let action = UIAlertAction(title: okString, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alert(message: String, title: String, button1: String, button2: String? = nil, button3: String? = nil, action:@escaping (Int)->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            let action1 = UIAlertAction(title: button1, style: .default) { _ in
                action(0)
            }
            alert.addAction(action1)
            if button2 != nil {
                let action2 = UIAlertAction(title: button2, style: .destructive) { _ in
                    action(1)
                }
                alert.addAction(action2)
            }
            
            if button3 != nil {
                let action3 = UIAlertAction(title: button3, style: .default) { _ in
                    action(2)
                }
                alert.addAction(action3)
            }
            // alert.show()
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func presentAnimation(_ viewControllerToPresent: UIViewController, direction: CATransitionSubtype, duration: Double = 0.5) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = CATransitionType.push
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        // present(viewControllerToPresent, animated: false)
    }
    
    func dismissAnimation(direction: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = direction
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        // dismiss(animated: false)
    }
    
    
    func convertImageToString (img: UIImage) -> String {
        let imageData: Data = img.jpegData(compressionQuality: 1.0) ?? Data()
        // let imageData: Data = img.pngData() ?? Data()
        let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
        return imgString
    }
    
    func convertStringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
}

