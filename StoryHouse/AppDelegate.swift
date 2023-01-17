//
//  AppDelegate.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      /*  if let username = UserDefaultHelper.getChildname() {
            if (username.isEmpty) || (username == " ") {
                let viewController = HomeViewController.getInstance()
                AppDelegate.getAppDelegate().window?.rootViewController = viewController
            }
            else {
                UserDefaultHelper.setChildname(value: username)
                let viewController = TabbarViewController.getInstance()
                AppDelegate.getAppDelegate().window?.rootViewController = viewController
            }
        }
        */
        return true
    }
    
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    
}

