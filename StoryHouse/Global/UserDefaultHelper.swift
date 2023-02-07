//
//  UserDefaultHelper.swift
//  MyTalking_iOS
//
//  Created by kmsoft on 02/03/22.
//

import Foundation

class UserDefaultHelper {
    
    // MARK: 1. SET VOICE
    static func setVoice(value: String) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.VOICE)
        UserDefaults.standard.synchronize()
    }
    static func getVoice() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.VOICE)
    }
    
    // MARK: 2. SET GENDER
    static func setGender(value: String) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.GENDER)
        UserDefaults.standard.synchronize()
    }
    static func getGender() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.GENDER)
    }
    
    // MARK: 3. SET PARAGRAPH INDEX
    static func setParagraphIndex(value: Int) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.PARAGRAPH_INDEX)
        UserDefaults.standard.synchronize()
    }
    static func getParagraphIndex() -> Int? {
        return UserDefaults.standard.integer(forKey: Constant.UserDefault.PARAGRAPH_INDEX)
    }
    
    // MARK: 4. SET STORY NUMBER
    static func setSelectedStoryNumber(value: String?) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.STORY_NUMBER)
        UserDefaults.standard.synchronize()
    }
    static func getSelectedStoryNumber() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.STORY_NUMBER)
    }
    
    // MARK: 5. SET CHILD NAME
    static func setChildname(value: String) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.USERNAME )
        UserDefaults.standard.synchronize()
    }
    static func getChildname() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.USERNAME)
    }
    
    // MARK: 6. SET ONBOARDING DONE.
    static func set_Is_Onboarding_Done(value: Bool) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.IS_ONBOARDING_DONE )
        UserDefaults.standard.synchronize()
    }
    static func get_Is_Onboarding_Done() -> Bool? {
        return UserDefaults.standard.bool(forKey: Constant.UserDefault.IS_ONBOARDING_DONE)
    }
    
    // MARK: 7. SET VOICE IDENTIFIER.
    static func setVoiceIdentifier(value: String?) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.VOICE_IDENTIFIER)
        UserDefaults.standard.synchronize()
    }
    static func getVoiceIdentifier() -> String? {
        return UserDefaults.standard.string(forKey: Constant.UserDefault.VOICE_IDENTIFIER)
    }
    
    static func isFirstLaunch() -> Bool {
        return !UserDefaults.standard.bool(forKey: Constant.UserDefault.FIRST_LAUNCH)
    }
    
    static func setFirstLaunch(value: Bool) {
        UserDefaults.standard.setValue(!value, forKey: Constant.UserDefault.FIRST_LAUNCH)
        UserDefaults.standard.synchronize()
    }
    
    static func getLastAppOpen() -> Date? {
        return UserDefaults.standard.value(forKey: Constant.UserDefault.LAST_APP_OPEN) as? Date
    }
    
    static func setLastAppOpen(value: Date) {
        UserDefaults.standard.setValue(value, forKey: Constant.UserDefault.LAST_APP_OPEN)
        UserDefaults.standard.synchronize()
    }
    
    static func saveCurrentDate() {
        UserDefaults.standard.set(Date(), forKey: Constant.UserDefault.CURRENT_DATE)
        UserDefaults.standard.synchronize()
    }
    
    static func getCurrentDate() -> Date? {
        let storedDate = UserDefaults.standard.object(forKey: Constant.UserDefault.CURRENT_DATE) as? Date
        print("Stored Date: ", storedDate)
        return storedDate
    }
    
    
    static func clearUserdefault() {
        UserDefaultHelper.setVoice(value: "")
        UserDefaultHelper.setVoiceIdentifier(value: "")
        UserDefaultHelper.setGender(value: "")
        UserDefaultHelper.setParagraphIndex(value: 0)
        UserDefaultHelper.setSelectedStoryNumber(value: "000")
        UserDefaultHelper.set_Is_Onboarding_Done(value: false)
        UserDefaultHelper.setChildname(value: "")
    }
}
