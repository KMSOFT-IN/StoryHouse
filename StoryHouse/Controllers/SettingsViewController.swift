//
//  SettingsViewController.swift
//  StoryHouse
//
//  Created by kmsoft on 14/02/23.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var subscriptionTypeLabel: UILabel!
    @IBOutlet weak var expiredLabel:UILabel!
    
    static func getInstance() -> SettingsViewController {
        return Constant.Storyboard.SETTING.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.nameTextField.text = UserDefaultHelper.getChildname()
        self.checkSubscription()
    }
    
    func setCurrentSubScription(id: String) {
        switch id {
        case Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_MONTHLY_PREMIUM:
            self.subscriptionTypeLabel.text = "Storyteller 1 month"
            break;
        case Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_YEARLY_PREMIUM:
            self.subscriptionTypeLabel.text = "Storyteller 1 year"
            break;
        case Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_HERO_MONTHLY_PREMIUM:
            self.subscriptionTypeLabel.text = "Storyteller hero 1 month"
            break;
        case Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_HERO_YEARLY_PREMIUM:
            self.subscriptionTypeLabel.text = "Storyteller hero 1 year"
            break;
        default:
            self.subscriptionTypeLabel.text = "Free"
            break
        }
    }
    
    func checkSubscription() {
        let expireDate = UserDefaultHelper.getSubgscriptionExpireDate()
        if (Double(expireDate) ?? 0) > Date().timeIntervalSince1970 * 1000 {
            self.subscriptionTypeLabel.text = ""
            self.setCurrentSubScription(id: UserDefaultHelper.getSubgscriptionProductId())
            let date = (Date(timeIntervalSince1970: (Double(expireDate) ?? 0) / 1000))
            self.expiredLabel.text = date.toFullDateString
        } else {
            self.subscriptionTypeLabel.text = "Free"
            self.expiredLabel.text = "Never"
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if (self.nameTextField.text ?? "").isEmpty {
            Utility.alert(message: "Please enter name.")
        } else {
            AppData.sharedInstance.childName = self.nameTextField.text ?? ""
            UserDefaultHelper.setChildname(value: self.nameTextField.text ??  "")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func subscriptionButtonTapped(_ sender: UIButton) {
        let viewController = PremiumViewController.getInstance()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func termsButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: TERMS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func privacyButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: PRIVACY_POLICY_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func cancelSubscriptionTapped(_ sender: UIButton) {
        if let url = URL(string: "itms-apps://apps.apple.com/account/subscriptions") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
