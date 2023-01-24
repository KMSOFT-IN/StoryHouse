//
//  UserDefaultHelper.swift
//  MyTalking_iOS
//
//  Created by kmsoft on 02/03/22.
//

import Foundation

class UserDefaultHelper {
    
    // 1.
    static func setIsOnboardingDone(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: "OnBoarding")
        UserDefaults.standard.synchronize()
    }
    static func getIsOnboardingDone() -> Bool {
        return UserDefaults.standard.bool(forKey: "OnBoarding")
    }

    //2.0
    static func setVoice(value: String) {
        UserDefaults.standard.setValue(value, forKey: "voice")
        UserDefaults.standard.synchronize()
    }
    static func getVoice() -> String? {
        return UserDefaults.standard.string(forKey: "voice")
    }
       
    //3.0
    static func setGender(value: String) {
        UserDefaults.standard.setValue(value, forKey: "gender")
        UserDefaults.standard.synchronize()
    }
    static func getGender() -> String? {
        return UserDefaults.standard.string(forKey: "gender")
    }
    
    //3.0
    static func setParagraphIndex(value: Int) {
        UserDefaults.standard.setValue(value, forKey: "parIndex")
        UserDefaults.standard.synchronize()
    }
    static func getParagraphIndex() -> Int? {
        return UserDefaults.standard.integer(forKey: "parIndex")
    }
    
    static func setMagicalObjectIndex(value: Int) {
        UserDefaults.standard.setValue(value, forKey: "MagicalObjectIndex")
        UserDefaults.standard.synchronize()
    }
    static func getMagicalObjectIndex() -> Int? {
        return UserDefaults.standard.integer(forKey: "MagicalObjectIndex")
    }
    //4.0
    static func setChildname(value: String) {
        UserDefaults.standard.setValue(value, forKey: "childName" )
        UserDefaults.standard.synchronize()
    }
    static func getChildname() -> String? {
        return UserDefaults.standard.string(forKey: "childName")
    }
    
    
    static func clearUserdefault() {
        UserDefaultHelper.setIsOnboardingDone(value: false)
        UserDefaultHelper.setVoice(value: "")
        UserDefaultHelper.setGender(value: "")
        UserDefaultHelper.setChildname(value: "")
    }
}
