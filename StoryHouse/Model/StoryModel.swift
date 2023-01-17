//
//  StoryModel.swift
//  StoryHouse
//
//  Created by iMac on 17/01/23.
//

import Foundation

struct StoryModels: Codable {
    var story: [Story]?
}

struct Story : Codable {
    var storyNumber : String?
    var data : [ParagraphDetails]?
}

struct ParagraphDetails: Codable {
    var imageName: String?
    var he: String?
    var she: String?
}
