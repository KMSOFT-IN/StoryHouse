//
//  AppLogger.swift
//  StoryHouse
//
//  Created by iMac on 07/02/23.
//

import Foundation
import Mixpanel
import AppCenter
import AppCenterCrashes
import AppCenterAnalytics
import Firebase
import AppsFlyerLib

class AppLogger: NSObject {
    
    
    enum LogType: String {
        case verbose = "verbose"
        case debug = "debug"
        case info = "info"
        case warning = "warning"
        case error = "error"
    }
    
    override init() {
        super.init()
    }
    
    
    func setupLogger() {
        // Mixpanel
        Mixpanel.initialize(token: "bc09058a1d89f69fdd4833f99830197d", trackAutomaticEvents: true)
        Mixpanel.mainInstance().loggingEnabled = true
        //Appsflyer
        AppsFlyerLib.shared().appsFlyerDevKey = "28x4Bxon3ACMmL3HeZf6S9"
        AppsFlyerLib.shared().appleAppID = "1664656561"
        
        //Appcenter
        AppCenter.start(withAppSecret: "7f4cccd2-f138-4ba0-b3a0-38eb984c0721", services:[
            Analytics.self,
            Crashes.self
        ])
    }
    
    func logAnalyticsEvent(eventName: String, parameters: [String: Any]? = nil) {
        
        //Set Firebase event
        FirebaseAnalytics.Analytics.logEvent(eventName, parameters: parameters)

        var properties: [String : MixpanelType] = [:]
        if let p = parameters {
            for (key,value) in p {
                properties[key] = value as? MixpanelType
            }
        }

        //Set Mixpanel event
        Mixpanel.mainInstance().track(event: eventName, properties: properties)

        //Set Appsflyer event
        /*AppsFlyerLib.shared().logEvent(eventName, withValues: parameters);

        var param: [String : String] = [:]
        if let p = parameters {
            for (key,value) in p {
                param[key] = "\(value)"
            }
        }*/

        //Set Appcenter event
        //Analytics.trackEvent(eventName, withProperties: param)
    }
    
//    func logAnalyticsMixPanel(eventName: String, parameters: [String: Any]? = nil) {
//        var properties: [String : MixpanelType] = [:]
//        if let p = parameters {
//            for (key,value) in p {
//                properties[key] = value as? MixpanelType
//            }
//        }
//        Mixpanel.mainInstance().track(event: eventName, properties: properties)
//    }
//    
//    func logEventOnFirebase(eventName: String, parameters: [String: Any]? = nil) {
//        FirebaseAnalytics.Analytics.logEvent(eventName, parameters: parameters)
//    }
//    
//    func setUserPropertyLastAppOpen() {
//        let lastAppOpenTime = Int64((UserDefaultHelper.getLastAppOpen() ?? Date()).timeIntervalSince1970)
//        FirebaseAnalytics.Analytics.setUserProperty("\(lastAppOpenTime)", forName: Constant.Analytics.LAST_APP_OPEN)
//        Mixpanel.mainInstance().people.set(property: Constant.Analytics.LAST_APP_OPEN, to: "\(lastAppOpenTime)")
//        AppsFlyerLib.shared().customData?[Constant.Analytics.LAST_APP_OPEN] = lastAppOpenTime
//        Analytics.trackEvent(Constant.Analytics.LAST_APP_OPEN, withProperties: ["LAST_APP_OPEN" : "\(lastAppOpenTime)"])
//    }
    
    func setUserProperty(userId: String) {
        FirebaseAnalytics.Analytics.setUserID(userId)
        Mixpanel.mainInstance().createAlias(Constant.Analytics.USER_ID, distinctId: userId)
        Mixpanel.mainInstance().people.set(property: Constant.Analytics.USER_ID, to: userId)
        Mixpanel.mainInstance().userId = userId
//        AppsFlyerLib.shared().customerUserID = userId
//        AppCenter.userId = userId
    }
}
