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
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createMyStoryButtonTapped(_ sender: UIButton) {
        
        if let storyIndex = Int("\(AppData.sharedInstance.selectedCharacterIndex)\(AppData.sharedInstance.selectedLocationIndex)\(AppData.sharedInstance.selectedMagicalObjectIndex)") {
            UserDefaultHelper.setSelectedStoryNumber(value: storyIndex)
            UserDefaultHelper.set_Is_Onboarding_Done(value: true)
        }
        let viewController = LoadingViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
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
        let image = self.magicalObjectList[indexPath.item].imageName
        cell.imageView.image = UIImage(named: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = self.magicalObjectList[indexPath.item].tag
        AppData.sharedInstance.selectedMagicalObjectIndex = self.selectedIndex
        UserDefaultHelper.setParagraphIndex(value: 0)
        self.magicalObjectCollectionView.reloadData()
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

