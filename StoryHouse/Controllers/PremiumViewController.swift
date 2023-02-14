//
//  PremiumViewController.swift
//  StoryHouse
//
//  Created by iMac on 08/02/23.
//

import UIKit

class PremiumViewController: InAppPurchaseViewController {

    @IBOutlet weak var shadowView: UIView!
    
    
    static func getInstance() -> PremiumViewController {
        return Constant.Storyboard.PREMIUM.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setShadow()
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pruchaseButtonTapped(_ sender: UIButton) {
        self.purchaseWithProductId(productId: Constant.IN_APP_PURHCHASE_PRODUCTS.PREMIUM_MONTH)
    }

}
