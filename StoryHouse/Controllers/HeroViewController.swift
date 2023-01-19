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
    var selectedIndex = 0
    let gifHandler: Gif = Gif()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.heroCollectionView.dataSource  = self
        self.heroCollectionView.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self.view) else { return }
        let hitView = self.view.hitTest(location, with: event)
        // if hitView == self.view {
        let view = UIView(frame: CGRect(x: location.x - 50, y: location.y - 50, width: 100, height: 100))
        self.view.addSubview(view)
        self.gifHandler.setUpGif(name: "star", duration: 1, view: view)
        //}
    }
    
    static func getInstance() -> HeroViewController {
        return Constant.Storyboard.CATEGORY.instantiateViewController(withIdentifier: "HeroViewController") as! HeroViewController
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        sender.showAnimation {
            let viewController = PlacesViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
            
      /*  sender.alpha = 0.8

          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) {
              sender.alpha = 1.0
              
          }
        */
      //  let viewController = HeroNameViewController.getInstance()
       // viewController.selectedHero = self.storyImage[selectedIndex]
   //     self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension HeroViewController: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        cell.imageBorderView.borderWidth = 0
        if (indexPath.item == self.selectedIndex) {
            cell.imageBorderView.borderWidth = 6
        }
        let image = storyImage[indexPath.item]
        cell.imageView.image = UIImage(named: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! imageCollectionViewCell
        self.selectedIndex = indexPath.item
        self.heroCollectionView.reloadData()
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
