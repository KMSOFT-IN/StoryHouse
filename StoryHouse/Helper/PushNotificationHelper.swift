//
//  PushNotificationHelper.swift
//  Astronme
//
//  Created by KMSOFT on 11/11/20.
//  Copyright © 2020 Logileap. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase
import FirebaseMessaging
import FirebaseAnalytics

import UIKit

enum PushNotifcationStatus {
    case allowed
    case haveNotAskedYet
    case denied
}

class PushNotificationHelper: NSObject {
    
    static let center = UNUserNotificationCenter.current()
    let notificationHandler: NotificationHandler = AppNotificationHandler()
    
    func setupDelegate() {
        PushNotificationHelper.center.delegate = self
        Messaging.messaging().delegate = self
    }
    
    func registerForPushNotifications(callback: ((Bool) -> Void)? = nil) {
        PushNotificationHelper.center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
            callback?(granted)
        }
        let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Open", comment: ""), options: UNNotificationActionOptions.foreground)
        let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
        PushNotificationHelper.center.setNotificationCategories(Set([deafultCategory]))
        UIApplication.shared.registerForRemoteNotifications()
        self.updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            AppData.sharedInstance.fcmToken = token
            UserDefaultHelper.setFCMToken(value: token)
        }
    }
    
    static func isNotificationPermissionAllowed(callback: ((_ status: PushNotifcationStatus) -> Void)?) {
        var notificationPermissionGiven: PushNotifcationStatus = .haveNotAskedYet
        PushNotificationHelper.center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                // Notification permission has not been asked yet, go for it!
                notificationPermissionGiven = .haveNotAskedYet
            } else if settings.authorizationStatus == .denied {
                // Notification permission was previously denied, go to settings & privacy to re-enable
                notificationPermissionGiven = .denied
            } else if settings.authorizationStatus == .authorized {
                // Notification permission was already granted
                notificationPermissionGiven = .allowed
            }
            callback?(notificationPermissionGiven)
        }
        
    }
    
}
extension PushNotificationHelper : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token:  ", fcmToken ?? "")
        updateFirestorePushTokenIfNeeded()
        connectToFcm()
    }
    
    func connectToFcm() {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
                return
            }
            else if let token = token {
                AppData.sharedInstance.fcmToken = token
                UserDefaultHelper.setFCMToken(value: token)
                print("Remote instance ID token: \(token)")
            }
        }
    }
}

extension PushNotificationHelper: UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // This gets the information needed in your notification payload
        let userInfo = notification.request.content.userInfo
        let aps = userInfo["aps"] as? [String : AnyObject] ?? [:]
        let alert = aps["alert"] as? [String : AnyObject] ?? [:]
        let messageKey = userInfo["messageKey"] as? String
        print("APS:", aps)
        print("ALERT", alert)
        completionHandler([.alert, .badge, .sound])
    }
    
    func addNotification(content: UNNotificationContent, trigger: UNNotificationTrigger?, indentifier: String){
        let request = UNNotificationRequest(identifier: indentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject{
                print("Error \(error.localizedDescription) in notification \(indentifier)")
            }
        })
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        let userInfo = response.notification.request.content.userInfo
        _ = notificationHandler.handle(notification: userInfo, appState: UIApplication.shared.applicationState)
        completionHandler()
    }
}

class PushNotificationSender {
    // It is used for Message alert
    func sendPushNotification(to token: String, title: String, body: String, data: [String: Any] = [:], withSound : Bool = true) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        print("SEND TOKEN:", token)
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title,
                                                             "body" : body,
                                                             "sound": withSound ? "default" : "none"],
                                           "data" : data.count == 0 ? nil : data,
                                           "content_available": true
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(SERVER_KEY)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            }
            catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
    
    
    func sendPushNotificationForMyAreaChat(to token: String, title: String, body: String ,locationKey: String, messageKey: String, withSound : Bool = true) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        print("SEND TOKEN:", token)
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title,
                                                             "body" : body,
                                                             "sound": withSound ? "default" : "none"],
                                           "data": ["type" : ""],
                                           "content_available": true,
                                           
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(SERVER_KEY)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
