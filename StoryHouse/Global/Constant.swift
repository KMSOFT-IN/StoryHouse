//
//  Constant.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import Foundation
import UIKit

let APPNAME = "Magic House"
let PRIVACY_POLICY_URL = "https://www.iubenda.com/privacy-policy/46923166"
let TERMS_URL = "https://www.iubenda.com/terms-and-conditions/46923166"

let GRAY_COLOR = UIColor(hex: "#808080")
let LIGHT_BLUE = UIColor(hex: "#ADD8E6")!

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
    }
}

enum GENDER: String {
    case BOY = "boy"
    case GIRL = "girl"
}


