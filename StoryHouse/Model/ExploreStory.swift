//
//  ExploreStory.swift
//  StoryHouse
//
//  Created by kmsoft on 17/02/23.
//

import Foundation

class ExploreStory {

    var id: String?
    var animalName: String?
    var childName: String?
    var heroName: String?
    var placeName: String?
    var storyImage: String?
    var storyNumber: String?
    var animalCharacterIndex: Int?
    var locationIndex: Int?
    var magicalObjectName: String?
    var createdAt: Double?
    
    init(id : String?,
         animalName : String?,
         childName : String?,
         heroName : String?,
         placeName : String?,
         storyImage : String?,
         storyNumber : String?,
         animalCharacterIndex : Int?,
         locationIndex : Int?,
         magicalObjectName : String?,
         createdAt : Double?) {
        
        self.id = id
        self.animalName = animalName
        self.childName = childName
        self.heroName = heroName
        self.placeName = placeName
        self.storyImage = storyImage
        self.storyNumber = storyNumber
        self.animalCharacterIndex = animalCharacterIndex
        self.locationIndex = locationIndex
        self.magicalObjectName = magicalObjectName
        self.createdAt = createdAt
        
    }

    func getDictionary() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["id"] = self.id ?? ""
        dictionary["animalName"] = self.animalName ?? ""
        dictionary["childName"] = self.childName ?? ""
        dictionary["heroName"] = self.heroName ?? ""
        dictionary["placeName"] = self.placeName ?? ""
        dictionary["storyImage"] = self.storyImage ?? ""
        dictionary["storyNumber"] = self.storyNumber ?? ""
        dictionary["animalCharacterIndex"] = self.animalCharacterIndex ?? 0
        dictionary["locationIndex"] = self.locationIndex ?? 0
        dictionary["magicalObjectName"] = self.magicalObjectName ?? ""
        dictionary["createdAt"] = self.createdAt ?? 0.0
        return dictionary
    }
    
    static func get(list: [ExploreStory]) -> [[String: Any]] {
        var array: [[String: Any]] = []
        for object in list {
            array.append(object.getDictionary())
        }
        return array
    }
    
    class func getInstanceFrom(dictionary: [String: Any]) -> ExploreStory? {
        let id = dictionary["id"] as? String
        let animalName = dictionary["animalName"] as? String
        let childName = dictionary["childName"] as? String
        let heroName = dictionary["heroName"] as? String
        let placeName = dictionary["placeName"] as? String
        let storyImage = dictionary["storyImage"] as? String
        let storyNumber = dictionary["storyNumber"] as? String
        let animalCharacterIndex = dictionary["animalCharacterIndex"] as? Int
        let locationIndex = dictionary["locationIndex"] as? Int
        let magicalObjectName = dictionary["magicalObjectName"] as? String
        let createdAt = dictionary["createdAt"] as? Double
        let exploreStory = ExploreStory(id: id,
                                        animalName: animalName,
                                        childName: childName,
                                        heroName: heroName,
                                        placeName: placeName,
                                        storyImage: storyImage,
                                        storyNumber: storyNumber,
                                        animalCharacterIndex: animalCharacterIndex,
                                        locationIndex: locationIndex,
                                        magicalObjectName: magicalObjectName,
                                        createdAt: createdAt)

        return exploreStory
    }
    
    class func getInstanceFrom(array: [[String: Any]]) -> [ExploreStory]? {
        var list: [ExploreStory] = []
        for o in array {
            if let instance = ExploreStory.getInstanceFrom(dictionary: o) {
                list.append(instance)
            }
        }
        return list.count == 0 ? nil : list
    }
}
