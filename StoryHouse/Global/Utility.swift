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
        let voiceList = AVSpeechSynthesisVoice.speechVoices().filter({$0.language.contains("en")})
        if let grandmaVoice = voiceList.filter({$0.name.contains("Grandma")}).first {
            utterance.voice = AVSpeechSynthesisVoice(identifier: grandmaVoice.identifier)
        } else if let marthaVoice = voiceList.filter({$0.name.contains("Martha")}).first {
            utterance.voice = AVSpeechSynthesisVoice(identifier: marthaVoice.identifier)
        } else if let karenVoice = voiceList.filter({$0.name.contains("Karen")}).first {
            utterance.voice = AVSpeechSynthesisVoice(identifier: karenVoice.identifier)
        }
//        if let identifier = UserDefaultHelper.getVoiceIdentifier() {
//            utterance.voice = AVSpeechSynthesisVoice(identifier: identifier)
//        }
        AppData.sharedInstance.synthesizer!.speak(utterance)
    }
    
    class func setVoiceIdentifier() {
        let voiceList = AVSpeechSynthesisVoice.speechVoices().filter({$0.language.contains("en")})
        if let grandmaVoice = voiceList.filter({$0.name.contains("Grandma")}).first {
            UserDefaultHelper.setVoiceIdentifier(value: grandmaVoice.identifier)
        } else if let marthaVoice = voiceList.filter({$0.name.contains("Martha")}).first {
            UserDefaultHelper.setVoiceIdentifier(value: marthaVoice.identifier)
        } else if let karenVoice = voiceList.filter({$0.name.contains("Karen")}).first {
            UserDefaultHelper.setVoiceIdentifier(value: karenVoice.identifier)
        }
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
    
    class func showAlert(title: String, message: String, viewController: UIViewController, okButtonTitle: String, isCancelButtonNeeded: Bool = false, cancelButtonTitle: String = "Cancel", okClicked: ((_ text: String) -> Void)? = nil, cancelClicked: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: {
            alert -> Void in
            okClicked?((alertController.textFields![0] as UITextField).text!)
        }))
        if isCancelButtonNeeded {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                cancelClicked?()
            }))            
        }
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
    
    class func alertWithTextField(title: String, message: String, keyboardType: UIKeyboardType, okButtonTitle: String = "OK", isCancelButtonNeeded: Bool = false, cancelButtonTitle: String = "Cancel", textFieldPlaceHolder: String = "", defaultString: String = "", okClicked: ((_ text: String) -> Void)? = nil, cancelClicked: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = textFieldPlaceHolder
            textField.keyboardType = keyboardType
            if defaultString != "" {
                textField.text = defaultString
            }
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            cancelClicked?()
        }))
        
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default, handler: {
            alert -> Void in
            okClicked?((alertController.textFields![0] as UITextField).text!)
        }))
        alertController.show()
    }
    
    class func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    class func findDateDiff(time1Str: String, time2Str: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "hh:mm:ss a"

        guard let time1 = timeformatter.date(from: time1Str),
            let time2 = timeformatter.date(from: time2Str) else { return "" }

        //You can directly use from here if you have two dates

        let interval = time2.timeIntervalSince(time1)
        let hour = interval / 3600;
        let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
        let secods  =  interval.truncatingRemainder(dividingBy: 60)
        let intervalInt = Int(interval)
        return "\(intervalInt < 0 ? "-" : "+") \(Int(hour)) Hours \(Int(minute)) Minutes \(Int(secods)) secods"
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
