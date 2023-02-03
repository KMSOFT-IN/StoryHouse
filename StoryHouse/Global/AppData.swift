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
    
    var selectedCharacterIndex: Int = 0
    var selectedLocationIndex: Int = 0
    var selectedMagicalObjectIndex: Int = 0
    var selectedStoryNumber : Int = 0
    
    static let sharedInstance: AppData = {
        let instance = AppData()
        return instance
    }()
    
    private init() {}
    
    static func resetData() {
        AppData.sharedInstance.childName = ""
        AppData.sharedInstance.selectedCharacterIndex = 0
        AppData.sharedInstance.selectedLocationIndex = 0
        AppData.sharedInstance.selectedMagicalObjectIndex = 0
    }

}
