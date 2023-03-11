//
//  UserRecording.swift
//  StoryHouse
//
//  Created by kmsoft on 27/02/23.
//

import Foundation
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

typealias ErrorCallback = (Error?) -> Void
typealias StoryCallback = (Bool, [StoryDetails]?, Error?) -> Void


class StoryDetails {
    var uniqueShareId: String?
    var id: String = ""
    var userId: String?
    var storyId: String?
    var paragraph: [Paragraph] = []
    var createdAt: Double?
    static var databaseRef = Constant.refs.STORIES
    
    init(dictionary: [String: Any]) {
        self.uniqueShareId = dictionary["uniqueShareId"] as? String
        self.id = dictionary["id"] as? String ?? ""
        self.userId = dictionary["userId"] as? String
        self.storyId = dictionary["storyId"] as? String
        self.createdAt = dictionary["createdAt"] as? Double
        if let temp = dictionary["paragraph"] as? [[String:Any]] {
            self.paragraph = Paragraph.getArray(array: temp) ?? []
        }
    }
    
    init(uniqueShareId: String = "",
         id: String = "",
         userId: String = "",
         createdAt: Double = 0.0,
         storyId: String = "",
         paragraph: [Paragraph] = []) {
        self.uniqueShareId = uniqueShareId
        self.id = id
        self.userId = userId
        self.storyId = storyId
        self.createdAt = createdAt
        self.paragraph = paragraph
    }

    func getDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [:]
        dictionary["uniqueShareId"] = self.uniqueShareId
        dictionary["id"] = self.id
        dictionary["userId"] = self.userId
        dictionary["storyId"] = self.storyId
        dictionary["createdAt"] = self.createdAt
        dictionary["paragraph"] = Paragraph.getArrayFromData(data: paragraph)
        return dictionary
    }
    
    class func getArrayFromData(data: [StoryDetails]) -> [[String: Any]] {
        var arrayList: [[String: Any]] = []
        for obj in data {
            let model = obj.getDictionary()
            arrayList.append(model)
        }
        return arrayList
    }
    
    class func getInstance(dictionary: [String: Any]) -> StoryDetails? {
        let response = StoryDetails(dictionary: dictionary)
        return response
    }
    
    class func getArray(array: [[String: Any]]) -> [StoryDetails]? {
        var data: [StoryDetails]? = []
        for obj in array {
            if let temp = StoryDetails.getInstance(dictionary: obj) {
                data?.append(temp)
            }
        }
        return data
    }
    
    // MARK: - Save to Firebase
    func saveToFirebase() {
        if self.id.isEmpty {
            self.id = StoryDetails.databaseRef.document().documentID
        }
        StoryDetails.databaseRef.document(self.id).setData(self.getDictionary(), completion: { (error: Error?) in
            
        })
    }
    
   class func getStoryDetail(callback: StoryCallback?) {
       Constant.refs.STORIES.getDocuments {(snapshot, error) in
           if let err = error {
               print("Error getting documents: \(err)")
               callback?(false, nil, error)
           } else {
               var tempArray: [StoryDetails] = []
               for document in snapshot!.documents {
                   let model = StoryDetails(dictionary: document.data())
                   tempArray.append(model)
               }
               callback?(true, tempArray, nil)
           }
       }
//       StoryDetails.databaseRef.document(uid).getDocument(completion: { (snapshot, error) in
//            if error != nil {
//                callback?(false,nil, error)
//            } else {
//                let dictionary = snapshot?.data() ?? [:]
//                let story = StoryDetails(dictionary: dictionary)
//                callback?(true, story, nil)
//            }
//        })
    }
    
    class func saveToFirebase(story: StoryDetails, callback: ErrorCallback?) {
//        story.updatedAt = Date().timeIntervalSince1970
        let dictionary = story.getDictionary()
        StoryDetails.databaseRef.document(story.id).setData(dictionary, completion: { (error) in
            if error != nil {
                callback?(error)
            }
            else {
//                if AppData.sharedInstance.user?.uid == user.uid {
//                    AppData.sharedInstance.user = user
//                    UserDefaultHelper.saveUser(user: user)
//                }
                callback?(nil)
            }
        })
    }
    
    //UploadFile on Storage
    class func uploadAudio(recordingID: String, audioString: URL, callback: ((_ url: String?, _ error: Error?)-> Void)?) {
        let storageReference = Storage.storage().reference().child("Audios").child("\(Date().toStringYYYYMMDD)_\(recordingID).caf")
        do {
            let data = try Data(contentsOf: audioString)
            storageReference.putData(data, metadata: nil, completion: { (metadata, error) in
                if error == nil {
                    print("Successful audio upload")
                    storageReference.downloadURL(completion: { (url, error) in
                        if let error = error {
                            callback?(nil, error)
                        } else {
                            let audioUrl = url!.absoluteString
                            callback?(audioUrl, nil)
                        }
                    })
                } else {
                    callback?(nil, error)
                }
            })
        } catch {}
    }
}

class Paragraph {
    var index: String?
    var file_url: String?
    
    init(dictionary: [String: Any]) {
        self.index = dictionary["index"] as? String
        self.file_url = dictionary["file_url"] as? String
    }
    
    init(index: String = "",
         file_url: String = "") {
        self.index = index
        self.file_url = file_url
    }

    func getDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [:]
        dictionary["index"] = self.index
        dictionary["file_url"] = self.file_url
        return dictionary
    }
    
    class func getArrayFromData(data: [Paragraph]) -> [[String: Any]] {
        var arrayList: [[String: Any]] = []
        for obj in data {
            let model = obj.getDictionary()
            arrayList.append(model)
        }
        return arrayList
    }
    
    class func getInstance(dictionary: [String: Any]) -> Paragraph? {
        let response = Paragraph(dictionary: dictionary)
        return response
    }
    
    class func getArray(array: [[String: Any]]) -> [Paragraph]? {
        var data: [Paragraph]? = []
        for obj in array {
            if let temp = Paragraph.getInstance(dictionary: obj) {
                data?.append(temp)
            }
        }
        return data
    }
}


class User {
    var uid: String?
    var credit: Int?
    var createdAt: Double?
    var updatedAt: Double?
    
    static var databaseRef = Constant.refs.USERS
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String
        self.credit = dictionary["credit"] as? Int
        self.createdAt = dictionary["createdAt"] as? Double
        self.updatedAt = dictionary["updatedAt"] as? Double
    }
    
    init(uid: String = "",
         credit: Int = 0,
         createdAt: Double = 0.0,
         updatedAt: Double = 0.0) {
        self.uid = uid
        self.credit = credit
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    func getDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [:]
        dictionary["uid"] = self.uid
        dictionary["credit"] = self.credit
        dictionary["createdAt"] = self.createdAt
        dictionary["updatedAt"] = self.updatedAt
        return dictionary
    }
    
    class func getArrayFromData(data: [User]) -> [[String: Any]] {
        var arrayList: [[String: Any]] = []
        for obj in data {
            let model = obj.getDictionary()
            arrayList.append(model)
        }
        return arrayList
    }
    
    class func getInstance(dictionary: [String: Any]) -> User? {
        let response = User(dictionary: dictionary)
        return response
    }
    
    class func getArray(array: [[String: Any]]) -> [User]? {
        var data: [User]? = []
        for obj in array {
            if let temp = User.getInstance(dictionary: obj) {
                data?.append(temp)
            }
        }
        return data
    }
    
    class func saveToFirebase(user: User) {
        let dictionary = user.getDictionary()
        User.databaseRef.document(user.uid ?? "").setData(dictionary)
        AppData.sharedInstance.user = user
        UserDefaultHelper.saveUser(user: user)
    }
    
    class func saveToFirebase(user: User, callback: ErrorCallback?) {
        user.updatedAt = Date().timeIntervalSince1970
        let dictionary = user.getDictionary()
        User.databaseRef.document(user.uid ?? "").setData(dictionary, completion: { (error) in
            if error != nil {
                callback?(error)
            }
            else {
                if AppData.sharedInstance.user?.uid == user.uid {
                    AppData.sharedInstance.user = user
                    UserDefaultHelper.saveUser(user: user)
                }
                callback?(nil)
            }
        })
    }
    
    class func getUserDetail(uid: String, callback: ((_ status: Bool, _ user: User?, _ error: Error?)->Void)?) {
        print(uid)
        Constant.refs.USERS.document(uid).getDocument(completion: { (snapshot, error) in
            if error != nil {
                callback?(false,nil, error)
            } else {
                let dictionary = snapshot?.data() ?? [:]
                let user = User.getInstance(dictionary: dictionary)
                callback?(true, user, nil)
            }
        })
    }
}
