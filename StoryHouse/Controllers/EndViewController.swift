//
//  EndViewController.swift
//  StoryHouse
//
//  Created by iMac on 18/01/23.
//

import UIKit

class EndViewController: UIViewController {
    
    let gifHandler: Gif = Gif()
    @IBOutlet weak var celebrationView: UIView!
    var image = ""
    var imageTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.gifHandler.setUpGif(name: "strimmer", duration: 6, view: self.celebrationView)
        UserDefaultHelper.setParagraphIndex(value: 0)
    }
    
    static func getInstance() -> EndViewController {
        return Constant.Storyboard.END.instantiateViewController(withIdentifier: "EndViewController") as! EndViewController
    }
    
    @IBAction func createNewStoryButtonTapped(_ sender: UIButton) {
        let viewController = HomeViewController.getInstance()
        viewController.isFromTabbar = true
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
    }
    
    @IBAction func homebuttonTapped(_ sender: UIButton) {
        let viewController = HomeViewController.getInstance()
        UserDefaultHelper.set_Is_Onboarding_Done(value: false)
        viewController.isFromTabbar = true
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
    }
    
    @IBAction func readAgainButtontapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //let image = UIImage(named: "AppIcon")!
        let image = UIImage(named: self.image) ?? UIImage(named: "ic_placeHolder")
        let textToShare = self.imageTitle
        UIGraphicsEndImageContext()
        let childName = (UserDefaultHelper.getChildname() ?? "") + "'s ’s Magic House Story"
        //if let myWebsite = URL(string: "http://itunes.apple.com/app/id1645684020") {
        let objectsToShare = [childName ,  textToShare , image] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true, completion: nil)
    }
}
