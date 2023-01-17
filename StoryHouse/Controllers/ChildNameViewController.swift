//
//  ChildNameViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.
//

import UIKit

class ChildNameViewController: UIViewController {

    @IBOutlet weak var childNameTextFeild: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var storyLeft: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    static func getInstance() -> ChildNameViewController {
        return Constant.Storyboard.ONBOARDING.instantiateViewController(withIdentifier: "ChildNameViewController") as! ChildNameViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.nextButton.applyappColorShadow()
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        self.childNameTextFeild.text = ""
    }
    
    @IBAction func moreChildButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func upgradeButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if childNameTextFeild.text == "" || childNameTextFeild.text?.isEmpty ?? false {
            self.alert(message: "Please enter your child name.")
            return
        }
        AppData.sharedInstance.childName = self.childNameTextFeild.text
        
        let viewCOntroller = SelectStoryViewController.getInstance()
        self.navigationController?.pushViewController(viewCOntroller, animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        
    }
}
