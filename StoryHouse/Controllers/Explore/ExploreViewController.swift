//
//  ExploreViewController.swift
//  StoryHouse
//
//  Created by kmsoft on 17/02/23.
//

import UIKit

class ExploreViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataLabel: UILabel!
    var exploreStoryList: [ExploreStory] = []
    
    static func getInstance() -> ExploreViewController {
        return Constant.Storyboard.EXPLORE.instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpCollectionView()
    }
    
    func setUpCollectionView() {
        self.exploreStoryList = UserDefaultHelper.getExploreStory() ?? []
        if self.exploreStoryList.isEmpty {
            self.collectionView.isHidden = true
            self.noDataLabel.isHidden = false
        } else {
            self.collectionView.isHidden = false
            self.noDataLabel.isHidden = true
        }
        self.collectionView.register(UINib(nibName: "ExploreCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExploreCollectionViewCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        let vc = SettingsViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.exploreStoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreCollectionViewCell", for: indexPath) as! ExploreCollectionViewCell
        cell.storyImageView.image = UIImage(named: self.exploreStoryList[indexPath.row].storyImage ?? "ic_placeHolder")
        let childname = self.exploreStoryList[indexPath.row].childName ?? UserDefaultHelper.getChildname() ?? ""
        let heroName = self.exploreStoryList[indexPath.row].heroName ?? ""
        let placeName = self.exploreStoryList[indexPath.row].placeName ?? ""
        let animalName = self.exploreStoryList[indexPath.row].animalName ?? ""
        let objectName = self.exploreStoryList[indexPath.row].magicalObjectName ?? ""
        cell.storyTitleLabel.attributedText = self.setAttributedTextForStoryTitle(childName: childname, heroName: heroName, placeName: placeName, animalName: animalName, objectName: objectName)
        let doubleDate = Double(self.exploreStoryList[indexPath.row].createdAt ?? 0.0)
        cell.dateLabel.text = Date(timeIntervalSince1970: doubleDate / 1000).toFullDateString
        cell.deleteButton.tag = indexPath.item
        cell.deleteButton.addTarget(self, action: #selector(self.deleteExploreStory(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteExploreStory(_ sender: UIButton) {
        Utility.alert(message: "Are you sure you want to delete this story?", title: APPNAME, button1: "Cancel", button2: "Delete", viewController: self) { index in
            if index == 1 {
                if let tempId = self.exploreStoryList[sender.tag].id {
                    self.exploreStoryList.removeAll(where: {$0.id == tempId})
                    UserDefaultHelper.saveExploreStory(exploreStoryList: self.exploreStoryList)
                    if self.exploreStoryList.isEmpty {
                        self.collectionView.isHidden = true
                        self.noDataLabel.isHidden = false
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setAttributedTextForStoryTitle(childName: String, heroName: String, placeName: String, animalName: String, objectName: String) -> NSMutableAttributedString {
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 22.0)!, NSAttributedString.Key.foregroundColor : UIColor(hex: "#292B5C")!]
        
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Poppins-Bold", size: 22.0)!, NSAttributedString.Key.foregroundColor : UIColor(hex: "#292B5C")!]
        
        let attributedString1 = NSMutableAttributedString(string: "\(childName)'s ", attributes:attrs2)
        
        let attributedString2 = NSMutableAttributedString(string: "story of ", attributes:attrs1)
        
        let attributedString3 = NSMutableAttributedString(string: heroName, attributes:attrs2)
        
        let attributedString4 = NSMutableAttributedString(string: "\n the \(animalName), in ", attributes:attrs1)
        
        let attributedString5 = NSMutableAttributedString(string: placeName, attributes:attrs2)
        
        let attributedString6 = NSMutableAttributedString(string: ",\n with \(objectName).", attributes:attrs1)
        
        attributedString1.append(attributedString2)
        attributedString1.append(attributedString3)
        attributedString1.append(attributedString4)
        attributedString1.append(attributedString5)
        attributedString1.append(attributedString6)
        return attributedString1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 391.0
        let height = 542.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
}
