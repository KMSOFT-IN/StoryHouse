//
//  ChildNameViewController.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.
//

import UIKit

class ChildNameViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var childNameTextFeild: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    var isGirlSelected: Bool  = true
    
    @IBOutlet weak var storyLeft: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isGirlSelected {
            self.femaleButton.setImage(UIImage(named: "ic_fill_radio"), for: .normal)
        }
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
        let check = childNameTextFeild.text?.trim?.count ?? 0   
        if check < 3 {
            self.alert(message: "Please enter atleast three character.")
            return
        }
        
        UserDefaultHelper.setChildname(value: self.childNameTextFeild.text ?? "")
        //AppData.sharedInstance.childName = self.childNameTextFeild.text
        
        let viewCOntroller = SelectStoryViewController.getInstance()
        self.navigationController?.pushViewController(viewCOntroller, animated: true)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        AppData.sharedInstance.childName = " "
        UserDefaultHelper.clearUserdefault()
    }
    
    @IBAction func termsButtonTapped(_ sender: Any) {
        guard let url = URL(string: TERMS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        guard let url = URL(string: PRIVACY_POLICY_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func QuestionGenderButtonTapped(_ sender: UIButton) {
        let popController = UIStoryboard(name: "Onboarding", bundle: nil).instantiateViewController(withIdentifier: "popoverId")
        popController.preferredContentSize = CGSize(width: 250  ,height: 250)
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(popController, animated: true, completion: nil)
    }
        
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    @IBAction func femaleRadionButtonTapped(_ sender: UIButton) {
        self.isGirlSelected = true
        self.setRadioButton()
    }
    func setRadioButton() {
        if self.isGirlSelected {
            self.femaleButton.setImage(UIImage(named: "ic_fill_radio"), for: .normal)
            self.maleButton.setImage(UIImage(named: "ic_radio"), for: .normal)
        }
        else
        {
            self.maleButton.setImage(UIImage(named: "ic_fill_radio"), for: .normal)
            self.femaleButton.setImage(UIImage(named: "ic_radio"), for: .normal)
        }
    }
    
    @IBAction func maleRadioButtonTapped(_ sender: UIButton) {
        self.isGirlSelected = false
        self.setRadioButton()
    }
    
    
}
