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
    @IBOutlet weak var femaleRadioImageView: UIImageView!
    @IBOutlet weak var maleRadioImageView: UIImageView!
    @IBOutlet weak var storyLeft: UILabel!
    
    var isGirlSelected: Bool  = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
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
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
            if self.childNameTextFeild.text == "" || self.childNameTextFeild.text?.isEmpty ?? false {
                self.alert(message: "Please enter your child name.")
                return
            }
            
            let check = self.childNameTextFeild.text?.trim?.count ?? 0
            
            if check < 3 {
                self.alert(message: "Please enter atleast three character.")
                return
            }
            
            UserDefaultHelper.setChildname(value: self.childNameTextFeild.text ?? "")
            if self.isGirlSelected {
                UserDefaultHelper.setGender(value: GENDER.GIRL.rawValue)
            }
            else {
                UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
            }
            
            let viewController = HomeViewController.getInstance()
            viewController.isFromTabbar = false
            self.navigationController?.pushViewController(viewController, animated: true)
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
        popController.preferredContentSize = CGSize(width: 150  ,height: 150)
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
    
    
    @IBAction func girlButtonTapped(_ sender: Any) {
        self.setReferenceSelectionImage(selectedImage: self.femaleRadioImageView)
    }
    
    @IBAction func boyButtonTapped(_ sender: Any) {
        self.setReferenceSelectionImage(selectedImage: self.maleRadioImageView)
    }
    
    func setReferenceSelectionImage(selectedImage: UIImageView) {
        self.femaleRadioImageView.image = UIImage(named: "ic_radio")
        self.maleRadioImageView.image = UIImage(named: "ic_radio")
        selectedImage.image = UIImage(named: "ic_fill_radio")
    }
    
}
