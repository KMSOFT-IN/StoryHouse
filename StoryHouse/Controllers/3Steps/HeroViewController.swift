//
//  HeroViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class HeroViewController: UIViewController {

    @IBOutlet weak var heroCollectionView: UICollectionView!
    
    //let storyImage = ["ic_story1","ic_story2","ic_story3","ic_story4"]
    let storyImage = ["ic_char1","ic_char2","ic_char3","ic_char4"]
    var characterList : [CategoryModel] = []
    var selectedIndex = 0
    
    override func viewDidLoad() {
//        self.characterList = CategoryModel.characterList
        super.viewDidLoad()
//        self.heroCollectionView.dataSource  = self
//        self.heroCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 0
        self.characterList = CategoryModel.characterList
        self.heroCollectionView.dataSource  = self
        self.heroCollectionView.delegate = self
        self.heroCollectionView.reloadData()
    }
    
    static func getInstance() -> HeroViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "HeroViewController") as! HeroViewController
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let param = [Constant.Analytics.USER_ID: UserDefaultHelper.getUserId(),
                     "HERO_INDEX" : self.selectedIndex] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.SELECTED_STORY_HERO, parameters: param)
        AppData.sharedInstance.selectedCharacterIndex =  self.selectedIndex
        let viewController = HeroNameViewController.getInstance()//PlacesViewController.getInstance()
        viewController.selectedImage = UIImage(named: self.storyImage[self.selectedIndex])
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        let viewController = SettingsViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HeroViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterList.count
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
        let image = characterList[indexPath.item].imageName
        cell.imageView.image = UIImage(named: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
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
        self.selectedIndex = self.characterList[indexPath.item].tag
        AppData.sharedInstance.selectedCharacterIndex = self.selectedIndex
        self.heroCollectionView.reloadData()
    }
    
    func navigateToSubscriptionScreen() {
        let viewController = PremiumViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HeroViewController : UICollectionViewDelegateFlowLayout {
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
