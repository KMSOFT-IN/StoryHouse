//
//  AppData.swift
//  Amber
//
//  Created by Bhautik Gadhiya on 12/5/17.
//  Copyright © 2017 Bhautik Gadhiya. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation

class AppData {
    
    var appDelegate: AppDelegate!
    var childName: String?
    var synthesizer: AVSpeechSynthesizer?
    var voiceIdentifier: String?
    var voice: String?
    var logger: AppLogger = AppLogger()
    
    var selectedCharacterIndex: Int = 0
    var selectedLocationIndex: Int = 0
    var selectedMagicalObjectIndex: Int = 0
    var selectedStoryNumber : String = "000"
    var storyCreatedCount : Int = 0
    var storyStartTime: String = "00"
    var storyEndTime: String = "00"
    var totalStroyReadingStartTime: String = "00"
    var totalStroyReadingEndTime: String = "00"
    var heroName: String = ""
    var placeName: String = ""
    var isSubscriptionActive: Bool = false
    var iAPProduct = IAPProduct()
    let notificationHelper = PushNotificationHelper()
    var fcmToken: String = ""
    static let sharedInstance: AppData = {
        let instance = AppData()
        return instance
    }()
    
    private init() {}
    
    static func resetData() {
        UserDefaultHelper.setChildname(value: "")
        AppData.sharedInstance.childName = ""
        AppData.sharedInstance.selectedCharacterIndex = 0
        AppData.sharedInstance.selectedLocationIndex = 0
        AppData.sharedInstance.selectedMagicalObjectIndex = 0
    }
    
    static func resetSubscription() {
        AppData.sharedInstance.isSubscriptionActive = false
        UserDefaultHelper.setSubscriptionActive(value: false)
        UserDefaultHelper.setSubscriptionExpireDate(value: "")
    }

}
