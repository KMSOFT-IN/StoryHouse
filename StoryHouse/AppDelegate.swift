//
//  AppDelegate.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit
import AppsFlyerLib
import FirebaseMessaging
import UserNotifications
import Firebase
import FirebaseRemoteConfig

 @main
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Utility.setVoiceIdentifier()
        AppData.sharedInstance.logger.setupLogger()
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().start(completionHandler: { (dictionary, error) in
            if (error != nil){
                print(error ?? "")
                return
            }
            else {
                print(dictionary ?? "")
                return
            }
        })
        self.launchLog()
        AppData.sharedInstance.isSubscriptionActive = UserDefaultHelper.getIsSubgscriptionActive()
        AppData.sharedInstance.notificationHelper.registerForPushNotifications()
        AppData.sharedInstance.notificationHelper.setupDelegate()
        AppData.sharedInstance.fcmToken = UserDefaultHelper.getFCMToken() ??  ""
        return true
    }
    
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }
    
    func launchLog() {
        if UserDefaultHelper.isFirstLaunch() {
            AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.FIRST_APP_OPEN, parameters: nil)
            UserDefaultHelper.setFirstLaunch(value: true)
        }
        if (UserDefaultHelper.getUser().isEmpty) {
            let userId = UUID().uuidString
            UserDefaultHelper.saveUser(userId: userId)
            AppData.sharedInstance.logger.setUserProperty(userId: userId)
        }
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.APP_OPEN, parameters: nil)
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.LAST_APP_OPEN, parameters: [Constant.Analytics.LAST_APP_OPEN : (UserDefaultHelper.getLastAppOpen() ?? Date()).getISO8601Date()])
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    class func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        }
        else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppsFlyerLib.shared().start()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            }
            else if let token = token {
                print("FCM registration token: \(token)")
                AppData.sharedInstance.fcmToken = token
                UserDefaultHelper.setFCMToken(value: token)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Fail to register notification")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    // When Noti. Arrives
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    // When USer Interact With Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notifications with the Local Notification Identifier")
        }
        
        completionHandler()
    }
}

extension UIApplication {
    // Get which VC in top Window
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}

