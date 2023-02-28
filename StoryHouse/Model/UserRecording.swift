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

class UserRecording {
    var url: String?
    var downloadUrl: String?
    var createdAt: Double?
    
    static var databaseRef = Constant.refs.USERRECORDINGS
    
    init(dictionary: [String: Any]) {
        self.url = dictionary["url"] as? String
        self.downloadUrl = dictionary["downloadUrl"] as? String
        self.createdAt = dictionary["createdAt"] as? Double
    }
    
    init(url: String = "",
         downloadUrl: String = "",
         createdAt: Double = 0.0) {
        self.downloadUrl = downloadUrl
        self.url = url
        self.createdAt = createdAt
    }

    func getDictionary() -> [String : Any] {
        var dictionary: [String: Any] = [:]
        dictionary["downloadUrl"] = self.downloadUrl
        dictionary["url"] = self.url
        dictionary["createdAt"] = self.createdAt
        return dictionary
    }
    
    class func getArrayFromData(data: [UserRecording]) -> [[String: Any]] {
        var arrayList: [[String: Any]] = []
        for obj in data {
            let model = obj.getDictionary()
            arrayList.append(model)
        }
        return arrayList
    }
    
    class func getInstance(dictionary: [String: Any]) -> UserRecording? {
        let response = UserRecording(dictionary: dictionary)
        return response
    }
    
    class func getArray(array: [[String: Any]]) -> [UserRecording]? {
        var data: [UserRecording]? = []
        for obj in array {
            if let temp = UserRecording.getInstance(dictionary: obj) {
                data?.append(temp)
            }
        }
        return data
    }
    
    // MARK: - Save to Firebase
    func saveToFirebase() {
        let dictionary = self.getDictionary()
        UserRecording.databaseRef.addDocument(data: dictionary)
        
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
