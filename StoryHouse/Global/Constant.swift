//
//  Constant.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseCore


let APPNAME = "Magic House"
let PRIVACY_POLICY_URL = "https://www.iubenda.com/privacy-policy/46923166"
let TERMS_URL = "https://www.iubenda.com/terms-and-conditions/46923166"
let FAQ_URL = "https://magichouse.studio/FAQ-a34dac768b77410ab965b520a2901d05"
let APPLINK = "https://apps.apple.com/us/app/magic-house-a-i/id1664656561"
let GRAY_COLOR = UIColor(hex: "#808080")
let LIGHT_BLUE = UIColor(hex: "#ADD8E6")!


#if DEBUG
let SERVER_KEY = "AAAAPlBGAWM:APA91bH7La3bSL9Blp3TSrvTli5v73LdLAlcwAWyYfnV4beCb5FJEUTklxXqjY9TTGr-59ZEAJMjiIcs4vvyLwsdFuizKtI1-1adgBYeOTV7hoFSfdLASqsmVgLoojhOQ9WgWgr7bylT"
#else
let SERVER_KEY = "AAAAPlBGAWM:APA91bH7La3bSL9Blp3TSrvTli5v73LdLAlcwAWyYfnV4beCb5FJEUTklxXqjY9TTGr-59ZEAJMjiIcs4vvyLwsdFuizKtI1-1adgBYeOTV7hoFSfdLASqsmVgLoojhOQ9WgWgr7bylT"
#endif

class Constant {
    
    class Storyboard {
        static let MAIN                       = UIStoryboard(name: "Main", bundle: nil)
        static let ONBOARDING                 = UIStoryboard(name: "Onboarding", bundle: nil)
        static let LOADING                    = UIStoryboard(name: "Loading", bundle: nil)
        static let CATEGORY                   = UIStoryboard(name: "Category", bundle: nil)
        static let TABBAR                     = UIStoryboard(name: "Tabbar", bundle: nil)
        static let HOME                       = UIStoryboard(name: "Home", bundle: nil)
        static let END                        = UIStoryboard(name: "End", bundle: nil)
        static let SETTING                    = UIStoryboard(name: "Setting", bundle: nil)
        static let PREMIUM                    = UIStoryboard(name: "Premium", bundle: nil)
        static let EXPLORE                    = UIStoryboard(name: "Explore", bundle: nil)
    }
    
    class refs {
        static let USERRECORDINGS = Firestore.firestore().collection("UserRecordings")
    }
    
    class UserDefault {
        static let VOICE = "Voice"
        static let VOICE_IDENTIFIER = "VoiceIdentifier"
        static let GENDER = "Gender"
        static let FCMTOKEN = "FCMTOKEN"
        static let USERNAME = "User"
        static let IS_ONBOARDING_DONE = "isOnboardingDone" // for choosen three index from given Category .
        static let PARAGRAPH_INDEX  = "ParagraphIndex"
        static let STORY_NUMBER  = "StoryNumber"
        static let LAST_APP_OPEN = "LAST_APP_OPEN"
        static let FIRST_LAUNCH = "FIRST_LAUNCH"
        static let SUBSCRIPTION_ACTIVE = "SUBSCRIPTION_ACTIVE"
        static let SUBSCRIPTION_EXPIRE_DATE = "SUBSCRIPTION_EXPIRE_DATE"
        static let SUBSCRIPTION_PRODUCT_ID = "SUBSCRIPTION_PRODUCT_ID"
        static let IS_REMEMBER = "IS_REMEMBER"
        static let CURRENT_DATE = "CURRENT_DATE"
        static let USER_ID = "USER_ID"
        static let USER_HERO_NAME = "USER_HERO_NAME"
        static let USER_PLACE_NAME = "USER_PLACE_NAME"
        static let EXPLORE_STORY = "EXPLORE_STORY"
        static let LAST_STORY_CREATE = "LAST_STORY_CREATE"
    }
    
    class Analytics {
        static let FIRST_APP_OPEN: String = "First_App_Open"
        static let APP_OPEN: String = "APP_OPEN"
        static let LAST_APP_OPEN: String = "LAST_APP_OPEN"
        static let APP_SESSION: String = "APP_SESSION"
        static let TOTAL_STORY_CREATED_COUNT_IN_SESSION = "TOTAL_STORY_CREATED_COUNT_IN_SESSION"
        static let TOTAL_STORY_READNIG_TIME = "TOTAL_STORY_READNIG_TIME"
        //When User Tap On Create My Story
        static let INITIATE_CREATE_STORY: String = "INITIATE_CREATE_STORY"
        static let SELECTED_STORY_HERO: String = "SELECTED_STORY_HERO"
        static let SELECTED_STORY_PLACE: String = "SELECTED_STORY_PLACE"
        static let SELECTED_STORY_OBJECT: String = "SELECTED_STORY_OBJECT"
        static let STORY_CREATED: String = "STORY_CREATED"
        static let ENTER_IN_BACKGROUND: String = "ENTER_IN_BACKGROUND"
        static let ENTER_IN_FOREGROUND: String = "ENTER_IN_FOREGROUND"
        static let STORY_READ_TIME: String = "STORY_READ_TIME"
        static let STORY_COMPLETED: String = "STORY_COMPLETED"
        static let SHARE_STORY: String = "SHARE_STORY"
        static let USER_ID = "USER_ID"
        static let NAME = "Name"
    }
    
    class IN_APP_PURHCHASE_PRODUCTS {
        
        static let PREMIUM_MONTH = "com.magichouse"
        static let STORYTELLER_MONTHLY_PREMIUM = "com.magichouse.storyteller.monthly"
        static let STORYTELLER_YEARLY_PREMIUM = "com.magichouse.storyteller.yearly"
        static let STORYTELLER_HERO_MONTHLY_PREMIUM = "com.magichouse.storyteller.hero.monthly"
        static let STORYTELLER_HERO_YEARLY_PREMIUM = "com.magichouse.storyteller.hero.yearly"
        
        //static let PREMIUM_MONTH = "in.kmsoft.storyTailor"
 
        static let LIST = [
            IN_APP_PURHCHASE_PRODUCTS.PREMIUM_MONTH,
            IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_MONTHLY_PREMIUM,
            IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_YEARLY_PREMIUM,
            IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_HERO_MONTHLY_PREMIUM,
            IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_HERO_YEARLY_PREMIUM
        ]
    }
}

enum GENDER: String {
    case BOY = "boy"
    case GIRL = "girl"
}

let YYYYMMDD = "yyyyMMdd"
let appFullDateFormat = "dd MMM yyyy"
let appDateFormat = "dd MMM"
let appTimeFormat = "hh:mm:ss a"


