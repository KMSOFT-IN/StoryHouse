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
        let param = [Constant.Analytics.USER_ID: UserDefaultHelper.getUser(),
                     "OBJECT_INDEX" : self.selectedIndex] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.SELECTED_STORY_OBJECT, parameters: param)
        let storyParam = [Constant.Analytics.USER_ID: UserDefaultHelper.getUser(),
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
        if Utility.isDebug() {
            let viewController = TabbarViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        } else {
            let viewController = LoadingViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func addTotalStoryCountEvent() {
        let diff = Utility.findDateDiff(time1Str: AppData.sharedInstance.totalStroyReadingStartTime, time2Str: AppData.sharedInstance.totalStroyReadingEndTime)
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.TOTAL_STORY_CREATED_COUNT_IN_SESSION, parameters: [Constant.Analytics.USER_ID: UserDefaultHelper.getUser(),
                        "COUNT" : AppData.sharedInstance.storyCreatedCount,
                        "start_time": AppData.sharedInstance.totalStroyReadingStartTime,
                        "end_time" : AppData.sharedInstance.totalStroyReadingEndTime,
                        "lapsed" : diff])
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

