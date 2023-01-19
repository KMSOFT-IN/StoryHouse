//
//  UIView.swift
//  MyTalking_iOS
//
//  Created by KMSOFT on 02/02/22.
//

import Foundation
import UIKit

extension UIView {
    
    
    func showAnimation(_ completionBlock: @escaping () -> Void) {
        isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
    
    
    func applyShadow(){
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor(hex: "#FD9935")?.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 6.0
        self.layer.masksToBounds = false
    }
    
    func applyappColorShadow(){
        //self.layer.cornerRadius = 8
        self.layer.masksToBounds = true;
        // self.backgroundColor = UIColor.white
        self.layer.shadowColor = UIColor(hex: "#FF9F3F")?.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0)
        self.layer.shadowRadius = 0.2
        self.layer.masksToBounds = false
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    //
    //    @IBInspectable var shadowColor: UIColor?{
    //        set {
    //            guard let uiColor = newValue else { return }
    //            layer.shadowColor = uiColor.cgColor
    //        }
    //        get{
    //            guard let color = layer.shadowColor else { return nil }
    //            return UIColor(cgColor: color)
    //        }
    //    }
    //
    //    @IBInspectable var shadowOpacity: Float{
    //        set {
    //            layer.shadowOpacity = newValue
    //        }
    //        get{
    //            return layer.shadowOpacity
    //        }
    //    }
    //
    //    @IBInspectable var shadowOffset: CGSize{
    //        set {
    //            layer.shadowOffset = newValue
    //        }
    //        get{
    //            return layer.shadowOffset
    //        }
    //    }
    //
    //    @IBInspectable var shadowRadius: CGFloat{
    //        set {
    //            layer.shadowRadius = newValue
    //        }
    //        get{
    //            return layer.shadowRadius
    //        }
    //    }
    
    func removeAllSubviews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    func animationShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
            self.center.y -= (self.bounds.height)
            self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    
    func animationHide(y:CGFloat){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
            self.center.y += self.bounds.height
            self.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
            self.isHidden = false
        })
    }
    
    func blinkView(repeatCount: Int, withDelay: Double, callback: ((_ completed: Bool)-> Void)?) {
        let duration = 0.10
        UIView.animate(withDuration: duration, delay: withDelay, options: [.curveLinear, .autoreverse], animations: {
            self.alpha = 1.0
        }, completion: {(_ completed: Bool) -> Void in
            if repeatCount > 0 {
                self.alpha = 0.5
                self.blinkView(repeatCount: repeatCount - 1, withDelay: 0, callback: callback)
            }
            else {
                callback?(true)
            }
            //callback?(true)
            //  print("Call Me")
        })
    }
    
}

@IBDesignable extension UIView {
    @IBInspectable var shadowColor: UIColor?{
        set {
            guard let uiColor = newValue else { return }
            layer.shadowColor = uiColor.cgColor
        }
        get{
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        set {
            layer.shadowOpacity = newValue
        }
        get{
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize{
        set {
            layer.shadowOffset = newValue
        }
        get{
            return layer.shadowOffset
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        set {
            layer.shadowRadius = newValue
        }
        get{
            return layer.shadowRadius
        }
    }
    
}
