//
//  PremiumViewController.swift
//  StoryHouse
//
//  Created by iMac on 08/02/23.
//

import UIKit

class PremiumViewController: InAppPurchaseViewController {

    
    static func getInstance() -> PremiumViewController {
        return Constant.Storyboard.HOME.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
