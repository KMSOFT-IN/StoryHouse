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
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.magicalObjectCollectionView.dataSource  = self
        self.magicalObjectCollectionView.delegate = self
    }
    
    static func getInstance() -> MagicalObjectViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "MagicalObjectViewController") as! MagicalObjectViewController
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self.view) else { return }
        let hitView = self.view.hitTest(location, with: event)
        // if hitView == self.view {
        let view = UIView(frame: CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100))
        self.view.addSubview(view)
        //}
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func createMyStoryButtonTapped(_ sender: UIButton) {
        sender.showAnimation {
            let viewController = LoadingViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)

        }
        
/*        sender.alpha = 0.8
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
              sender.alpha = 1.0
              let viewController = LoadingViewController.getInstance()
              self.navigationController?.pushViewController(viewController, animated: true)
          }
 */
    }
}




extension MagicalObjectViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        cell.imageBorderView.borderWidth = 0
        if (indexPath.item == self.selectedIndex) {
            cell.imageBorderView.borderWidth = 6
        }
        let image = magicalImages[indexPath.item]
        cell.imageView.image = UIImage(named: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
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

