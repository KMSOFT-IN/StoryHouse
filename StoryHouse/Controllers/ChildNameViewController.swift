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
    @IBOutlet weak var questionGenderButton: UIButton!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var storyLeft: UILabel!
    
    var isGirlSelected: Bool  = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setQuestionGenderButon()
    }
    
    static func getInstance() -> ChildNameViewController {
        return Constant.Storyboard.ONBOARDING.instantiateViewController(withIdentifier: "ChildNameViewController") as! ChildNameViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.nextButton.applyappColorShadow()
    }
    
    func setQuestionGenderButon() {
        let font = UIFont(name: "Poppins-Italic", size: 18) ?? UIFont.italicSystemFont(ofSize: 18)
        let attributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue,  NSAttributedString.Key.font: font]
        let attributeString = NSMutableAttributedString(string: "(Why are we asking)", attributes: attributes)
        self.questionGenderButton.setAttributedTitle(attributeString, for: .normal)
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
            /*
            if self.isGirlSelected {
                UserDefaultHelper.setGender(value: GENDER.GIRL.rawValue)
            }
            else {
                UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
            }*/
        
            UserDefaultHelper.setGender(value: GENDER.BOY.rawValue)
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
        guard let url = URL(string: FAQ_URL) else { return }
        UIApplication.shared.open(url)
    }
        
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    @IBAction func girlButtonTapped(_ sender: Any) {
        self.isGirlSelected = true
        self.femaleView.borderWidth = 2.5
        self.maleView.borderWidth = 0
    }
    
    @IBAction func boyButtonTapped(_ sender: Any) {
        self.isGirlSelected = false
        self.maleView.borderWidth = 2.5
        self.femaleView.borderWidth = 0
    }
    
}
