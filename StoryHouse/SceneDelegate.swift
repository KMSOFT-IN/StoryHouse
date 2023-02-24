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
        IAPProduct.setProductIndentifiers(productList: Constant.IN_APP_PURHCHASE_PRODUCTS.LIST)
        AppData.sharedInstance.iAPProduct.loadProdictList()
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
        self.checkSubscription()
        UIApplication.shared.applicationIconBadgeNumber = 0
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
                viewController.isFromExploreTab = false
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
    
    func checkSubscription() {
        let expireDate = UserDefaultHelper.getSubgscriptionExpireDate()
        if (Double(expireDate) ?? 0) > Date().timeIntervalSince1970 * 1000 {
            UserDefaultHelper.setSubscriptionActive(value: true)
            AppData.sharedInstance.isSubscriptionActive = true
        } else {
            
            if (Double(expireDate) ?? 0) > Date().adding(.day, value: 1).timeIntervalSince1970 * 1000 {
                AppData.resetSubscription()
            }
            AppData.sharedInstance.isSubscriptionActive = false
            UserDefaultHelper.setSubscriptionActive(value: false)
            self.checkUserHaveValidLicense { haveValidLicense, data, error in
                
            }
        }
    }
    
    func checkUserHaveValidLicense(callback: ((_ haveValidLicense: Bool, _ data: ReceiptValidation?, _ error: Error?) -> Void)?) {
        IAPProduct.store.receiptValidation { success, data, error in
            DispatchQueue.main.async {
                if success {
                    print(data ?? "Oh no")
                    if let dictionary = data as? [String: Any] {
                        if let receipt = ReceiptValidation.getInstance(dictionary: dictionary) {
                            if receipt.status == 0
                                && (Double(receipt.latest_receipt_info?.first?.expires_date_ms ?? "0") ?? 0) > Date().timeIntervalSince1970 * 1000 {
                                UserDefaultHelper.setSubscriptionActive(value: true)
                                UserDefaultHelper.setSubscriptionExpireDate(value: receipt.latest_receipt_info?.first?.expires_date_ms ?? "0")
                                UserDefaultHelper.setSubscriptionProductId(value: receipt.latest_receipt_info?.first?.product_id ?? "")
                                AppData.sharedInstance.isSubscriptionActive = true
                                callback?(true, receipt, nil)
                                return
                            }
                            else {
                                UserDefaultHelper.setSubscriptionProductId(value: "")
                                UserDefaultHelper.setSubscriptionExpireDate(value: "")
                                UserDefaultHelper.setSubscriptionActive(value: false)
                                AppData.sharedInstance.isSubscriptionActive = false
                            }
                            callback?(false, receipt, nil)
                            return
                        }
                    }
                    callback?(false, nil, nil)
                    return
                }
                else {
                    print(error?.localizedDescription ?? "")
                    callback?(false, nil, error)
                    return
                }
            }
        }
    }
    
}

