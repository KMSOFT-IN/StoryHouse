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
    var selectedCharacterIndex: Int?
    var selectedLocationIndex: Int?
    var selectedMagicalObjectIndex: Int?
    
    
    
    static let sharedInstance: AppData = {
        let instance = AppData()
        return instance
    }()
    
    private init() {}

}
