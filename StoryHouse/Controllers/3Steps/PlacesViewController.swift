//
//  PlacesViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class PlacesViewController: UIViewController {

    @IBOutlet weak var placesCollectionView: UICollectionView!
  //  let storyImage = ["ic_place1","ic_place2","ic_place3","ic_place4"]
    let storyImage = ["ic_locaction1","ic_locaction2","ic_locaction3","ic_locaction4"]
    var locationList : [CategoryModel] = []
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationList = CategoryModel.locationList
        self.placesCollectionView.dataSource  = self
        self.placesCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectedIndex = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let location = touches.first?.location(in: self.view) else { return }
//        let hitView = self.view.hitTest(location, with: event)
//        // if hitView == self.view {
//        let view = UIView(frame: CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100))
//        self.view.addSubview(view)
        //}
    }
    
    static func getInstance() -> PlacesViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "PlacesViewController") as! PlacesViewController
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        let childNameVC = ChildNameViewController.getInstance()
        self.navigationController?.setViewControllers([childNameVC], animated: true)
        AppData.resetData()
        self.navigationController?.popToRootViewController(animated: true)    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let param = [Constant.Analytics.USER_ID: UserDefaultHelper.getUser(),
                     "PLACE_INDEX" : self.selectedIndex] as [String : Any]
        AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.SELECTED_STORY_PLACE, parameters: param)
        AppData.sharedInstance.selectedLocationIndex = selectedIndex
            let viewController = MagicalObjectViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PlacesViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.locationList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        cell.imageBorderView.borderWidth = 0
        if (indexPath.item == self.selectedIndex) {
            cell.imageBorderView.borderWidth = 6
        }
        let image = self.locationList[indexPath.item].imageName
        cell.imageView.image = UIImage(named: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        self.selectedIndex = self.locationList[indexPath.item].tag
        AppData.sharedInstance.selectedLocationIndex = self.selectedIndex
        self.placesCollectionView.reloadData()
    }
}

extension PlacesViewController : UICollectionViewDelegateFlowLayout {
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
