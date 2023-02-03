//
//  HomeViewController.swift
//  StoryHouse
//
//  Created by iMac on 10/01/23.
//

import UIKit

class HomeViewController : UIViewController {

    @IBOutlet weak var childName: UILabel!
    @IBOutlet weak var createStoryView: UIView!
    @IBOutlet weak var exploreStoryView: UIView!
    @IBOutlet weak var backButton: UIButton!
    
    var isCreateStoryEnable : Bool = true
    var isFromTabbar : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = UserDefaultHelper.getChildname() ?? ""
        self.childName.text = "HELLO" + "\n\(name) !"
        self.setBorderWidth(view: self.createStoryView)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if self.isFromTabbar {
//            self.backButton.isHidden = true
//        }
//        else {
//            self.backButton.isHidden = false
//        }
    }
    
    static func getInstance() -> HomeViewController {
        return Constant.Storyboard.HOME.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    @IBAction func backButtontapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func settingButtontapped(_ sender: Any) {
        let childNameVC = ChildNameViewController.getInstance()
        self.navigationController?.setViewControllers([childNameVC], animated: true)
        AppData.resetData()
        self.navigationController?.popToRootViewController(animated: true)
    }
   
    func setBorderWidth(view: UIView) {
        self.createStoryView.borderWidth = 0
        self.exploreStoryView.borderWidth = 0
        view.borderWidth = 6
    }
    
    @IBAction func createStoryButtonTapped(_ sender: UIButton) {
        self.setBorderWidth(view: self.createStoryView)
        let viewController = HeroViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func exploreStoryButtonTapped(_ sender: UIButton) {
        self.setBorderWidth(view: self.exploreStoryView)
    }
    
}
