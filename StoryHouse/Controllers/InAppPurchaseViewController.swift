//
//  InAppPurchaseViewController.swift
//  StoryHouse
//
//  Created by iMac on 08/02/23.
//

import StoreKit
import UIKit
import SwiftyReceiptValidator

class InAppPurchaseViewController: UIViewController {

    @IBOutlet weak var progressView: UIActivityIndicatorView!
    var selectedProduct: String?
    let products = Constant.IN_APP_PURHCHASE_PRODUCTS.LIST
    var isFromPurchase = false
    var isReceiptValidationRunning: Bool = false
    
    var purchaseSucessfulCallback: (() -> Void)?
    var receiptValidator: SwiftyReceiptValidatorType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if Utility.isDebug() {
            AppData.sharedInstance.user?.premiumSubscription = Premium(productId: Constant.IN_APP_PURHCHASE_PRODUCTS.PREMIUM_QUATER,
                                                                       transactionId: "TestInAppPurchaseDebugiOS",
                                                                       subscriptionExpireDate: Date().adding(.minute, value: 10).timeIntervalSince1970)
            AppData.sharedInstance.user?.saveToFirebase()
        }*/
        let configuration = SRVConfiguration(
            productionURL: "https://buy.itunes.apple.com/verifyReceipt",
            sandboxURL: "https://sandbox.itunes.apple.com/verifyReceipt",
            sessionConfiguration: .default
        )
        
        self.receiptValidator = SwiftyReceiptValidator(configuration: configuration, isLoggingEnabled: false)
        AppData.sharedInstance.iAPProduct.delegate = self
        IAPProduct.setProductIndentifiers(productList: self.products)
        self.progressView.startAnimating()
        self.view.isUserInteractionEnabled = false
        AppData.sharedInstance.iAPProduct.loadProdictList()
        
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
    
    func purchaseWithProductId(productId: String) {
        self.isFromPurchase = true
        if let product = IAPProduct.productList.filter({$0.productIdentifier == productId}).first {
            self.progressView.startAnimating()
            self.view.isUserInteractionEnabled = false
            self.selectedProduct = product.productIdentifier
            AppData.sharedInstance.iAPProduct.purchaseProduct(product: product)
//            AppData.sharedInstance.logger.logAnalyticsInitiatePurchaseEvent(eventName: "InitiatePurchase", parameters: ["PRODUCT_ID":productId])
        }
    }
    
    func restore() {
        self.isFromPurchase = true
        self.progressView.startAnimating()
        self.view.isUserInteractionEnabled = false
        AppData.sharedInstance.iAPProduct.restorePurchase()
    }
}


extension InAppPurchaseViewController: IAPProductDelegate {
    
    func getProductList(productList: [SKProduct]) {
        DispatchQueue.main.async {
            if (!self.isFromPurchase) {
                self.progressView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
            //self.showView()
            if(productList.count <= 0) {
                Utility.alert(message: "Unable to get product on Apple Store. Please try again after sometime.", title: APPNAME, button1: "Ok", viewController: self) { index in
                }
            }
        }
    }
    
    func purchasedProductListWithIndex(transaction: SKPaymentTransaction, productList: [SKProduct], index: [Int]) {
        if (!self.isFromPurchase) {
            self.progressView.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        let filter = productList.filter({$0.productIdentifier == self.selectedProduct})
        if self.selectedProduct == Constant.IN_APP_PURHCHASE_PRODUCTS.PREMIUM_MONTH  {
            if(filter.count > 0) {
                self.checkUserHaveValidLicense { haveValidLicense, data, error in
                    if haveValidLicense {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                self.checkUserHaveValidLicense { haveValidLicense, data, error in
                    if haveValidLicense {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        else {
            self.progressView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.purchaseSucessfulCallback?()
            let transactopnId = transaction.transactionIdentifier ?? ""
            let productId = self.selectedProduct ?? ""
        }
    }
    
    func purchasedCancelWithError(error: NSError?) {
        DispatchQueue.main.async {
            self.progressView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if error?.code != 2 {
                Utility.alert(message: error?.localizedDescription ?? "Unable to complete transaction. Please try again.", title: APPNAME, button1: "Ok",viewController: self, action: { (index: Int) in
                })
            }
        }
    }
    
    func restoreWithError(error: NSError) {
        DispatchQueue.main.async {
            self.progressView.stopAnimating()
            self.view.isUserInteractionEnabled = true
            Utility.alert(message: error.localizedDescription, title: APPNAME,button1: "Ok", viewController: self ,action: { (index: Int) in
            })
        }
    }
    
    func checkUserHaveValidLicense(callback: ((_ haveValidLicense: Bool, _ data: ReceiptValidation?, _ error: Error?) -> Void)?) {
        if self.isReceiptValidationRunning {
            return
        }
        self.isReceiptValidationRunning = true
        IAPProduct.store.receiptValidation { success, data, error in
            DispatchQueue.main.async {
                self.progressView.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
            self.isFromPurchase = false
            self.isReceiptValidationRunning = false
            DispatchQueue.main.async {
                if success {
                    print(data ?? "Oh no")
                    if let dictionary = data as? [String: Any] {
                        if let receipt = ReceiptValidation.getInstance(dictionary: dictionary) {
                            if receipt.status == 0
                                && (Double(receipt.latest_receipt_info?.first?.expires_date_ms ?? "0") ?? 0) > Date().timeIntervalSince1970 * 1000
                                 {
//                                AppData.sharedInstance.logger.logAnalyticsPurchasedEvent(eventName: "PurchaseCompleted", parameters: ["PRODUCT_ID":self.selectedProduct ?? ""])
                                //logAnalyticsInitiatePurchaseEvent(eventName: "InitiatePurchase", parameters: ["PRODUCT_ID":productId])
                                UserDefaultHelper.setSubscriptionActive(value: true)
                                UserDefaultHelper.setSubscriptionExpireDate(value: receipt.latest_receipt_info?.first?.expires_date_ms ?? "0")
                                AppData.sharedInstance.isSubscriptionActive = true
                                self.purchaseSucessfulCallback?()
                                callback?(true, receipt, nil)
                                return
                            }
                            else {
                                UserDefaultHelper.setSubscriptionExpireDate(value: "")
                                UserDefaultHelper.setSubscriptionActive(value: false)
                                AppData.sharedInstance.isSubscriptionActive = false
                                Utility.alert(message: "Subscription is expired. Please renew.", title: APPNAME,button1: "Ok", viewController: self ,action: { (index: Int) in
                                })
                            }
                            callback?(false, receipt, nil)
                            return
                        }
                    }
                    callback?(false, nil, nil)
                    return
                }
                else {
                    print(error?.localizedDescription ?? "")
                    callback?(false, nil, error)
                    return
                }
            }
        }
    }
}
