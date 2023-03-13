//
//  PremiumViewController.swift
//  StoryHouse
//
//  Created by iMac on 08/02/23.
//

import UIKit
import MHLoadingButton

class PremiumViewController: InAppPurchaseViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowView1: UIView!
    @IBOutlet weak var storytellerMonthlySelected: UIView!
    @IBOutlet weak var storytellerYearlySelected: UIView!
    @IBOutlet weak var storytellerHeroMonthlySelected: UIView!
    @IBOutlet weak var storytellerHeroYearlySelected: UIView!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!

    
    var selectedProductId = Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_YEARLY_PREMIUM
    
    static func getInstance() -> PremiumViewController {
        return Constant.Storyboard.PREMIUM.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadow()
        self.setSelectedItemBorder(item: 1)
    }
    
    func setShadow() {
        self.shadowView.layer.cornerRadius = 8
        self.shadowView.layer.masksToBounds = true;
        self.shadowView.backgroundColor = UIColor.white
        self.shadowView.layer.shadowColor = UIColor(hex: "#DCD9D9")?.cgColor
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowView.layer.shadowRadius = 10.0
        self.shadowView.layer.masksToBounds = false
        self.shadowView1.layer.cornerRadius = 8
        self.shadowView1.layer.masksToBounds = true;
        self.shadowView1.backgroundColor = UIColor.white
        self.shadowView1.layer.shadowColor = UIColor(hex: "#DCD9D9")?.cgColor
        self.shadowView1.layer.shadowOpacity = 0.8
        self.shadowView1.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.shadowView1.layer.shadowRadius = 10.0
        self.shadowView1.layer.masksToBounds = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setSelectedItemBorder(item: Int) {
        self.storytellerYearlySelected.borderColor = .clear
        self.storytellerMonthlySelected.borderColor = .clear
        self.storytellerHeroMonthlySelected.borderColor = .clear
        self.storytellerHeroYearlySelected.borderColor = .clear
        self.storytellerYearlySelected.borderWidth = 0
        self.storytellerMonthlySelected.borderWidth = 0
        self.storytellerHeroMonthlySelected.borderWidth = 0
        self.storytellerHeroYearlySelected.borderWidth = 0
        
        if item == 0 {
            self.storytellerMonthlySelected.borderColor = UIColor(hex: "#")
            self.storytellerMonthlySelected.borderWidth = 1
        } else if item == 1 {
            self.storytellerYearlySelected.borderColor = UIColor(hex: "#")
            self.storytellerYearlySelected.borderWidth = 1
        } else if item == 2 {
            self.storytellerHeroMonthlySelected.borderColor = UIColor(hex: "#")
            self.storytellerHeroMonthlySelected.borderWidth = 1
        } else if item == 3 {
            self.storytellerHeroYearlySelected.borderColor = UIColor(hex: "#")
            self.storytellerHeroYearlySelected.borderWidth = 1
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pruchaseButtonTapped(_ sender: UIButton) {
        if self.selectedProductId.isEmpty {
            Utility.alert(message: "Please select any subscriptions.")
        } else {
            self.purchaseWithProductId(productId: self.selectedProductId)
        }
    }
    
    @IBAction func storytellerMonthlyButtton(_ sender: UIButton) {
        self.selectedProductId = Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_MONTHLY_PREMIUM
        self.setSelectedItemBorder(item: 0)
    }
    
    @IBAction func storytellerYearlyButtton(_ sender: UIButton) {
        self.selectedProductId = Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_YEARLY_PREMIUM
        self.setSelectedItemBorder(item: 1)
    }
    
    @IBAction func storytellerHeroMonthlyButtton(_ sender: UIButton) {
        self.selectedProductId = Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_HERO_MONTHLY_PREMIUM
        self.setSelectedItemBorder(item: 2)
    }
    
    @IBAction func storytellerHeroYearlyButtton(_ sender: UIButton) {
        self.selectedProductId = Constant.IN_APP_PURHCHASE_PRODUCTS.STORYTELLER_HERO_YEARLY_PREMIUM
        self.setSelectedItemBorder(item: 3)
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let vc = SettingsViewController.getInstance()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func restoreButtonTapped(_ sender: UIButton) {
        self.restore()
    }
    
    @IBAction func termsButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: TERMS_URL) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func privacyButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: PRIVACY_POLICY_URL) else { return }
        UIApplication.shared.open(url)
    }
}
