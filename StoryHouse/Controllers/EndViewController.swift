//
//  EndViewController.swift
//  StoryHouse
//
//  Created by iMac on 18/01/23.
//

import UIKit
import LinkPresentation

class EndViewController: UIViewController {
    
    let gifHandler: Gif = Gif()
    @IBOutlet weak var celebrationView: UIView!
    var image = ""
    var imageTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultHelper.set_Is_Onboarding_Done(value: false)
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
        self.addWaterMarkToImage { tempImage in
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            var image = UIImage(named: self.image)
            if tempImage != nil {
                image = tempImage
            }
            UIGraphicsEndImageContext()
    //        let childName = (UserDefaultHelper.getChildname() ?? "") + "'s Magic House Story, assisted by MagicalHouse.studio\n\(self.imageTitle.text ?? "")"
            if let i = image {
                let objectsToShare = [i, self] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
                activityVC.popoverPresentationController?.sourceView = sender
                AppData.sharedInstance.logger.logAnalyticsEvent(eventName: Constant.Analytics.SHARE_STORY, parameters: ["STORY_INDEX" : AppData.sharedInstance.selectedStoryNumber])
                self.present(activityVC, animated: true, completion: nil)
            }
            else {
                // handle error
            }
        }
    }
    
    @IBAction func shareButtontapped(_ sender: Any) {
        
        
    }
    
    func addWaterMarkToImage(_ callBack: ((_ image: UIImage?) -> Void)?) {
        if let backgroundImage = UIImage(named: self.image) {
            let watermarkImage = #imageLiteral(resourceName: "watermark")
            
            let size = backgroundImage.size
            let scale = backgroundImage.scale
            
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            backgroundImage.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
            watermarkImage.draw(in: CGRect(x: 10, y: size.height - 260, width: 250, height: 250))
            
            if let result = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                callBack?(result)
            }
            callBack?(nil)
        } else {
            callBack?(nil)
        }
    }
}

extension EndViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
//        let childName = (UserDefaultHelper.getChildname()?.capitalizingFirstLetter() ?? "") + "'s Magic House Story, assisted by MagicalHouse.studio\n\(self.imageTitle.text ?? "")"
        let childName = (UserDefaultHelper.getChildname()?.capitalizingFirstLetter() ?? "")+"'s created a story on Magic House. Create your own: \(APPLINK).\n\(self.imageTitle)"
        return childName
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = (UserDefaultHelper.getChildname()?.capitalizingFirstLetter() ?? "")+"'s created a story on Magic House. Create your own: \(APPLINK).\n\(self.imageTitle)"
//        "\(UserDefaultHelper.getChildname() ?? "") 's Story, assisted by MagicalHouse.studio\n\(self.imageTitle.text ?? "")"
//        let image = UIImage(named: self.paragraphDetails?[self.currentIndex].imageName ?? "ic_placeHolder")!
//        metadata.iconProvider = NSItemProvider(object: image)
        return metadata
    }
}
