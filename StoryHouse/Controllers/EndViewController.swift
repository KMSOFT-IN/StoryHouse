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
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.gifHandler.setUpGif(name: "celebration", duration: 5, view: self.celebrationView)
        } */
        
    }
    
    static func getInstance() -> EndViewController {
        return Constant.Storyboard.END.instantiateViewController(withIdentifier: "EndViewController") as! EndViewController
    }
    
    @IBAction func createNewStoryButtonTapped(_ sender: Any) {
        
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
       // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIImage(named: "AppIcon")!
        UIGraphicsEndImageContext()
        let textToShare = "Check out Magic House app"
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1645684020") {
            let objectsToShare = [textToShare, myWebsite, image] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
        
    
    
}
