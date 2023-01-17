//
//  SelectStoryViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class SelectStoryViewController: UIViewController {

    
    @IBOutlet weak var childName: UILabel!
    
    
    @IBOutlet weak var createStoryView: UIView!
    @IBOutlet weak var exploreStoryView: UIView!
    
    @IBOutlet weak var createStoryButton: UIButton!
    @IBOutlet weak var exploreStoryButton: UIButton!
    
    var isCreateStoryEnable : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let name = AppData.sharedInstance.childName ?? ""
        let name = UserDefaultHelper.getChildname() ?? ""
        self.childName.text = "HELLO" + "\n\(name)"
        self.setUpUI(isCreateTrue: isCreateStoryEnable)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    static func getInstance() -> SelectStoryViewController {
        return Constant.Storyboard.MAIN.instantiateViewController(withIdentifier: "SelectStoryViewController") as! SelectStoryViewController
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(isCreateTrue: Bool) {
        if isCreateTrue {
            self.createStoryView.borderWidth = 6
            self.createStoryButton.tintColor = UIColor.white
            self.createStoryButton.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.5529411765, blue: 0.2509803922, alpha: 1)
            
            self.exploreStoryView.borderWidth = 0
            self.exploreStoryButton.tintColor = UIColor(hex: "000072")
            self.exploreStoryButton.backgroundColor = UIColor.white
        }
        else {
            self.exploreStoryView.borderWidth = 6
            self.exploreStoryButton.tintColor = UIColor.white
            self.exploreStoryButton.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.5529411765, blue: 0.2509803922, alpha: 1)
            
            self.createStoryView.borderWidth = 0
            self.createStoryButton.tintColor = UIColor(hex: "000072")
            self.createStoryButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func createStoryButtonTapped(_ sender: UIButton) {
        
        if isCreateStoryEnable {
            self.setUpUI(isCreateTrue: isCreateStoryEnable)
        }
        else {
            isCreateStoryEnable = !isCreateStoryEnable
            self.setUpUI(isCreateTrue: isCreateStoryEnable)
        }
        
            let viewController = HeroViewController.getInstance()
            self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func exploreStoryButtonTapped(_ sender: UIButton) {
        if !isCreateStoryEnable {
            return
        }
        isCreateStoryEnable = !isCreateStoryEnable
        self.setUpUI(isCreateTrue: isCreateStoryEnable)
       
    }
    
}
