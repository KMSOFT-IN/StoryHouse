//
//  AppDelegate.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
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
//        AppData.sharedInstance.logger.setUserPropertyLastAppOpen()
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
}

extension UIApplication {
    // Get which VC in top Window
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

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

