//
//  Utility.swift
//  KMSOFT
//
//  Created by Akash Trivedi on 10/24/17.
//  Copyright © 2017 KMSOFT. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import NaturalLanguage
import AVFoundation

@objc class Utility: NSObject {
    
    static func isDebug() -> Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    class func playAudio(text: String) {
        AppData.sharedInstance.synthesizer?.stopSpeaking(at: AVSpeechBoundary.immediate)
        if AppData.sharedInstance.synthesizer == nil {
            AppData.sharedInstance.synthesizer = AVSpeechSynthesizer()
        }
        let utterance = AVSpeechUtterance(string: text)
        if let identifier = UserDefaultHelper.getVoiceIdentifier() {
            utterance.voice = AVSpeechSynthesisVoice(identifier: identifier)
        }
        AppData.sharedInstance.synthesizer!.speak(utterance)
    }
     
    class func getDateFromTimeStamp(timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "hh:mm a"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    
    class func getDate(format: String, timeStamp : Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory + "/"
    }
    
    class func showAlertWithTextField(title: String, message: String, viewController: UIViewController, okButtonTitle: String, isCancelButtonNeeded: Bool = false, cancelButtonTitle: String = "Cancel", textFieldPlaceHolder: String = "", defaultString: String = "", okClicked: ((_ text: String) -> Void)? = nil, cancelClicked: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = textFieldPlaceHolder
        }
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: {
            alert -> Void in
            okClicked?((alertController.textFields![0] as UITextField).text!)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            cancelClicked?()
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {
        completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    static func getStringFrom(seconds: Int) -> String {
        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    static func seconds2Timestamp(intSeconds:Int)->String {
        let mins:Int = intSeconds/60
        let hours:Int = mins/60
        let secs:Int = intSeconds%60
        
        let strTimestamp:String = ((hours<10) ? "0" : "") + String(hours) + ":" + ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        return strTimestamp
    }
    
    class func alert(message: String, title: String? = APPNAME) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okString = "OK"
            let action = UIAlertAction(title: okString, style: .cancel, handler: nil)
            alert.addAction(action)
            alert.show()
        }
    }
    
    class func alert(message: String, title: String, button1: String, button2: String? = nil, button3: String? = nil, action:@escaping (Int)->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let action1 = UIAlertAction(title: button1, style: .default) { _ in
                action(0)
            }
            alert.addAction(action1)
            if button2 != nil {
                let action2 = UIAlertAction(title: button2, style: .default) { _ in
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
            alert.show()
        }
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    
}

private var kAlertControllerWindow = "kAlertControllerWindow"
extension UIAlertController {
    
    var alertWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(self, &kAlertControllerWindow) as? UIWindow
        }
        set {
            objc_setAssociatedObject(self, &kAlertControllerWindow, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func show() {
        show(animated: true)
    }
    
    func show(animated: Bool) {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self, animated: animated, completion: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertWindow?.isHidden = true
        alertWindow = nil
    }
}
