//
//  SceneDelegate.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit
import Firebase
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Mixpanel

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

     var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        self.splashScreen()
        FirebaseApp.configure()
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    private func splashScreen() {
        let launchScreenVC = UIStoryboard.init(name: "LaunchScreen", bundle: nil)
        let rootVC = launchScreenVC.instantiateViewController(withIdentifier: "splashController")
        self.window?.rootViewController = rootVC
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(dismissSplashController), userInfo: nil, repeats: false)
    }
    
    @objc func dismissSplashController() {
        let name = UserDefaultHelper.getChildname()
        var navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        if (name == nil) || (name?.isEmpty ?? false) {
            let viewController = ChildNameViewController.getInstance()
            navigationController = UINavigationController(rootViewController: viewController)
        } else {
            if UserDefaultHelper.get_Is_Onboarding_Done() ?? false {
                let viewController = TabbarViewController.getInstance()
                navigationController = UINavigationController(rootViewController: viewController)
            }
            else {
                let viewController = HomeViewController.getInstance()
                navigationController = UINavigationController(rootViewController: viewController)
            }
        }
        self.window?.rootViewController = navigationController
        self.window?.isUserInteractionEnabled = true
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
    }
    
}

