//
//  StoryModel.swift
//  StoryHouse
//
//  Created by iMac on 17/01/23.
//

import Foundation

struct StoryModels: Decodable {
    var story: [Story]?
}

struct Story : Decodable {
    var storyNumber : String?
    var data : [ParagraphDetails]?
}

struct ParagraphDetails: Decodable {
    var imageName: String?
    var he: String?
    var she: String?
}
