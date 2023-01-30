//
//  Category.swift
//  StoryHouse
//
//  Created by iMac on 30/01/23.
//

import Foundation

class CategoryModel {
    let imageName: String
    let tag : Int
    
    init(imageName: String, tag: Int) {
        self.imageName = imageName
        self.tag = tag
    }
    
    static var characterList: [CategoryModel] = [
        //let storyImage = ["ic_char1","ic_char2","ic_char3","ic_char4"]
        CategoryModel(imageName: "ic_char1", tag: 0) ,
        CategoryModel(imageName: "ic_char2", tag: 1) ,
        CategoryModel(imageName: "ic_char3", tag: 2) ,
        CategoryModel(imageName: "ic_char4", tag: 3) ,
    ]
    
    static var locationList : [CategoryModel] = [
        //let storyImage = ["ic_locaction1","ic_locaction2","ic_locaction3","ic_locaction4"]
        CategoryModel(imageName: "ic_locaction1", tag: 0),
        CategoryModel(imageName: "ic_locaction2", tag: 1),
        CategoryModel(imageName: "ic_locaction3", tag: 2),
        CategoryModel(imageName: "ic_locaction4", tag: 3)
    ]
    
    static var magicalObjectList : [CategoryModel] = [
        //["ic_object1","ic_object2","ic_object3","ic_object4"]
        CategoryModel(imageName: "ic_object1", tag: 0),
        CategoryModel(imageName: "ic_object2", tag: 1),
        CategoryModel(imageName: "ic_object3", tag: 2),
        CategoryModel(imageName: "ic_object4", tag: 3)
    ]
    
}




