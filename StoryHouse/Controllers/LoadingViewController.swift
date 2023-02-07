//
//  LoadingViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var chilldNameTitle: UILabel!
    @IBOutlet weak var loadingCollectionView: UICollectionView!
    
    let loadingDotsCount: Int = 15
    var loadingCount: Int = 1
    var selectedDot: Int = 0
    var timer: Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UserDefaultHelper.getChildname() ?? ""
        self.chilldNameTitle.text = "creating" + "\n \(name)" + "’s story!"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func navigateToTabbarViewController() {
        let viewController = TabbarViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    static func getInstance() -> LoadingViewController {
        return Constant.Storyboard.LOADING.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
    }

    @objc func timerAction() {
        self.selectedDot += 1
        self.loadingCollectionView.reloadData()
        if self.selectedDot == self.loadingDotsCount {
            self.selectedDot = 0
            if self.loadingCount == 2 {
                self.timer.invalidate()
                if AppData.sharedInstance.storyCreatedCount == 1 {
                    AppData.sharedInstance.storyStartTime = Date().toTimeString
                }
                let storyParam = ["startTime" : AppData.sharedInstance.storyStartTime,
                                  "endTime" : "",
                                  "lapsed" : ""]
                AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.STORY_READ_TIME, parameters: storyParam)
                self.navigateToTabbarViewController()
            }
            self.loadingCount += 1
        }
    }
    
}

extension LoadingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.loadingDotsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.loadingCollectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionViewCell", for: indexPath) as! LoadingCollectionViewCell
        cell.view.backgroundColor = UIColor(named: "sky_color(4BBFEF)")
        cell.view.alpha = 0.5
        if indexPath.item == self.selectedDot {
            cell.view.alpha = 1
        }
        return cell
    }
    
}
