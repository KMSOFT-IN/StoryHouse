//
//  MagicalObjectViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class MagicalObjectViewController: UIViewController {
    
    @IBOutlet weak var magicalObjectCollectionView: UICollectionView!
    let magicalImages = ["ic_object1","ic_object2","ic_object3","ic_object4"]
    var magicalObjectList : [CategoryModel] = []
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.magicalObjectList = CategoryModel.magicalObjectList
//        self.magicalObjectCollectionView.dataSource  = self
//        self.magicalObjectCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 0
        self.magicalObjectList = CategoryModel.magicalObjectList
        self.magicalObjectCollectionView.dataSource  = self
        self.magicalObjectCollectionView.delegate = self
        self.magicalObjectCollectionView.reloadData()
    }
    
    static func getInstance() -> MagicalObjectViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "MagicalObjectViewController") as! MagicalObjectViewController
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        let viewController = SettingsViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func createMyStoryButtonTapped(_ sender: UIButton) {
        AppData.sharedInstance.selectedMagicalObjectIndex = self.selectedIndex
        let storyIndex = ("\(AppData.sharedInstance.selectedCharacterIndex)"  + "\(AppData.sharedInstance.selectedLocationIndex)" + "\(AppData.sharedInstance.selectedMagicalObjectIndex)")
        UserDefaultHelper.setSelectedStoryNumber(value: storyIndex)
        UserDefaultHelper.set_Is_Onboarding_Done(value: true)
        let param = [Constant.Analytics.USER_ID: UserDefaultHelper.getUserId(),
                     "OBJECT_INDEX" : self.selectedIndex] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.SELECTED_STORY_OBJECT, parameters: param)
        let storyParam = [Constant.Analytics.USER_ID: UserDefaultHelper.getUserId(),
                          "HERO_INDEX": AppData.sharedInstance.selectedCharacterIndex,
                          "PLACE_INDEX": AppData.sharedInstance.selectedLocationIndex,
                          "OBJECT_INDEX": AppData.sharedInstance.selectedMagicalObjectIndex,
                          "STORY_INDEX" : storyIndex] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.STORY_CREATED, parameters: storyParam)
        AppData.sharedInstance.storyCreatedCount += 1
        if AppData.sharedInstance.storyCreatedCount == 1 {
            AppData.sharedInstance.totalStroyReadingStartTime = Date().toTimeString
        }
        self.addTotalStoryCountEvent()
        self.saveStoryInExplore()
        UserDefaultHelper.setLastStoryDate(value: "\(Date().timeIntervalSince1970)")
        if Utility.isDebug() {
            let viewController = TabbarViewController.getInstance()
            viewController.isFromExploreTab = false
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = LoadingViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        self.sendPushNotification()
    }
    
    func addTotalStoryCountEvent() {
        let diff = Utility.findDateDiff(time1Str: AppData.sharedInstance.totalStroyReadingStartTime, time2Str: AppData.sharedInstance.totalStroyReadingEndTime)
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.TOTAL_STORY_CREATED_COUNT_IN_SESSION, parameters: [Constant.Analytics.USER_ID: UserDefaultHelper.getUserId(),
                        "COUNT" : AppData.sharedInstance.storyCreatedCount,
                        "start_time": AppData.sharedInstance.totalStroyReadingStartTime,
                        "end_time" : AppData.sharedInstance.totalStroyReadingEndTime,
                        "lapsed" : diff])
    }
    
    func saveStoryInExplore() {
        let storyIndex = ("\(AppData.sharedInstance.selectedCharacterIndex)"  + "\(AppData.sharedInstance.selectedLocationIndex)" + "\(AppData.sharedInstance.selectedMagicalObjectIndex)")
        let id = self.randomString(length: 6)
        
        let animalName = Utility.getAnimalName(index: AppData.sharedInstance.selectedCharacterIndex)
        let childName = UserDefaultHelper.getChildname()
        let heroName = AppData.sharedInstance.heroName
        let placeName = AppData.sharedInstance.placeName
        let storyImage = "\(storyIndex)-1"
        let storyNumber = storyIndex
        let animalCharacterIndex = AppData.sharedInstance.selectedCharacterIndex
        let locationIndex = AppData.sharedInstance.selectedLocationIndex
        let magicalObjectName = Utility.getObjectName(index: AppData.sharedInstance.selectedMagicalObjectIndex)
        let createdAt = Date().timeIntervalSince1970
        let exploreStoryObject = ExploreStory(id: id,
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
        var tempObject = UserDefaultHelper.getExploreStory() ?? []
        tempObject.append(exploreStoryObject)
        UserDefaultHelper.saveExploreStory(exploreStoryList: tempObject)
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func sendPushNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "We missing you from 3 days", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "Hi \(UserDefaultHelper.getChildname() ?? ""), how about create a magical story tonight?", arguments: nil)
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let content1 = UNMutableNotificationContent()
        content1.title = NSString.localizedUserNotificationString(forKey: "We missing you from 7 days", arguments: nil)
        content1.body = NSString.localizedUserNotificationString(forKey: "Hi \(UserDefaultHelper.getChildname() ?? ""), how about create a magical story tonight?", arguments: nil)
        content1.sound = UNNotificationSound.default
        content1.badge = 1
        
        let content2 = UNMutableNotificationContent()
        content2.title = NSString.localizedUserNotificationString(forKey: "We missing you from 11 days", arguments: nil)
        content2.body = NSString.localizedUserNotificationString(forKey: "Hi \(UserDefaultHelper.getChildname() ?? ""), how about create a magical story tonight?", arguments: nil)
        content2.sound = UNNotificationSound.default
        content2.badge = 1
        
        var dateInfo = DateComponents()
        dateInfo.day = 3 //Put your day
        dateInfo.hour = 17 //Put your hour
        dateInfo.minute = 00 //Put your minutes
        
        var dateInfo1 = DateComponents()
        dateInfo1.day = 7 //Put your day
        dateInfo1.hour = 17 //Put your hour
        dateInfo1.minute = 00 //Put your minutes
        
        var dateInfo2 = DateComponents()
        dateInfo2.day = 11 //Put your day
        dateInfo2.hour = 17 //Put your hour
        dateInfo2.minute = 00 //Put your minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: true)
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateInfo1, repeats: true)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateInfo2, repeats: true)
        
        let request = UNNotificationRequest(identifier: "notification3", content: content, trigger: trigger)
        let request1 = UNNotificationRequest(identifier: "notification7", content: content1, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: "notification11", content: content2, trigger: trigger2)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        UNUserNotificationCenter.current().add(request1, withCompletionHandler: nil)
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
    }
    
}

extension MagicalObjectViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.magicalObjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        cell.imageBorderView.borderWidth = 0
        if (indexPath.item == self.selectedIndex) {
            cell.imageBorderView.borderWidth = 6
        }
        if !AppData.sharedInstance.isSubscriptionActive {
            if indexPath.row == 2 || indexPath.row == 3 {
                cell.lockImageView.isHidden = false
            } else {
                cell.lockImageView.isHidden = true
            }
        } else {
            cell.lockImageView.isHidden = true
        }

        let image = self.magicalObjectList[indexPath.item].imageName
        cell.imageView.image = UIImage(named: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppData.sharedInstance.isSubscriptionActive {
            self.didSelectCollectionView(indexPath: indexPath)
        } else {
            if indexPath.row == 2 || indexPath.row == 3 {
                self.navigateToSubscriptionScreen()
            } else {
                self.didSelectCollectionView(indexPath: indexPath)
            }
        }
    }
    
    func didSelectCollectionView(indexPath: IndexPath) {
        self.selectedIndex = self.magicalObjectList[indexPath.item].tag
        AppData.sharedInstance.selectedMagicalObjectIndex = self.selectedIndex
        UserDefaultHelper.setParagraphIndex(value: 0)
        self.magicalObjectCollectionView.reloadData()
    }
    
    func navigateToSubscriptionScreen() {
        let viewController = PremiumViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MagicalObjectViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.size.width / 4 - 10,
               height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

