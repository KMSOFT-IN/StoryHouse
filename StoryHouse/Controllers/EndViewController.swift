//
//  EndViewController.swift
//  StoryHouse
//
//  Created by iMac on 18/01/23.
//

import UIKit

class EndViewController: UIViewController {
    
    
    @IBOutlet weak var celebrationView: UIView!
    var image = ""
    var imageTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaultHelper.setParagraphIndex(value: 0)
    }
    static func getInstance() -> EndViewController {
        return Constant.Storyboard.END.instantiateViewController(withIdentifier: "EndViewController") as! EndViewController
    }
    
    @IBAction func createNewStoryButtonTapped(_ sender: Any) {
        let viewController = HomeViewController.getInstance()
        viewController.isFromTabbar = true
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        
        
    }
    
    @IBAction func homebuttonTapped(_ sender: Any) {
        
        let viewController = HomeViewController.getInstance()
        viewController.isFromTabbar = true
        var navigationController = UINavigationController()
        let window = self.view.window
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
       
    }
    
    @IBAction func readAgainButtontapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //let image = UIImage(named: "AppIcon")!
        let image = UIImage(named: image)!
        let textToShare = imageTitle
        UIGraphicsEndImageContext()
        let childName = (UserDefaultHelper.getChildname() ?? "") + "'s ’s Magic House Story"
        //if let myWebsite = URL(string: "http://itunes.apple.com/app/id1645684020") {
        let objectsToShare = [childName ,  textToShare , image] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        //}
    }
        
    
    
}
