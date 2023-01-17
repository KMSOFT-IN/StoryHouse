//
//  LoadingViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var chilldNameTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let name = AppData.sharedInstance.childName ?? ""
        let name = UserDefaultHelper.getChildname() ?? ""
        self.chilldNameTitle.text = "creating" + "\n \(name)" + "’s story!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewController = TabbarViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    static func getInstance() -> LoadingViewController {
        return Constant.Storyboard.LOADING.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
    }

}
