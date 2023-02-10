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
//        Utils.showProgress()
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
//        if Utility.isDebug() {
//            AppData.sharedInstance.logger.logAnalyticsInitiatePurchaseEvent(eventName: "InitiatePurchase", parameters: ["PRODUCT_ID":productId])
//        }
        self.isFromPurchase = true
        if let product = IAPProduct.productList.filter({$0.productIdentifier == productId}).first {
//            Utils.showProgress()
            self.selectedProduct = product.productIdentifier
            AppData.sharedInstance.iAPProduct.purchaseProduct(product: product)
//            AppData.sharedInstance.logger.logAnalyticsInitiatePurchaseEvent(eventName: "InitiatePurchase", parameters: ["PRODUCT_ID":productId])
        }
    }
    
    func restore() {
        self.isFromPurchase = true
//        Utils.showProgress()
        AppData.sharedInstance.iAPProduct.restorePurchase()
    }
}


extension InAppPurchaseViewController: IAPProductDelegate {
    
    func getProductList(productList: [SKProduct]) {
        DispatchQueue.main.async {
            if (!self.isFromPurchase) {
//                Utils.dismissProgress()
            }
            //self.showView()
            if(productList.count <= 0) {
                Utility.alert(message: "Unable to get product on Apple Store. Please try again after sometime.", title: APPNAME, button1: "Ok") { index in
                }
            }
        }
    }
    
    func purchasedProductListWithIndex(transaction: SKPaymentTransaction, productList: [SKProduct], index: [Int]) {
        if (!self.isFromPurchase) {
//            Utils.dismissProgress()
        }
        let filter = productList.filter({$0.productIdentifier == self.selectedProduct})
        if self.selectedProduct == Constant.IN_APP_PURHCHASE_PRODUCTS.PREMIUM_MONTH  {
            // Transaction is in queue, user has been charged.  Client should complete the transaction.
            let productId = transaction.payment.productIdentifier

            let validationRequest = SRVPurchaseValidationRequest(
                productId: productId,
                sharedSecret: "cd72731f425e40c39dc41f3603b37f26"
            )
                
            receiptValidator.validate(validationRequest) { result in
                switch result {
                case .success(let response):
                    defer {
                        // IMPORTANT: Finish the transaction ONLY after validation was successful
                        // if validation error e.g due to internet, the transaction will stay in pending state
                        // and than can/will be resumed on next app launch
//                        queue.finishTransaction(transaction)
                    }
                    print("Receipt validation was successfull with receipt response \(response)")
                    // Unlock products and/or do additional checks
                case .failure(let error):
                    print("Receipt validation failed with error \(error.localizedDescription)")
                    // Inform user of error
                }
            }

//            if(filter.count > 0) {
//                self.checkUserHaveValidLicense { haveValidLicense, data, error in
//                }
//            }
//            else {
//                self.checkUserHaveValidLicense { haveValidLicense, data, error in
//                }
//            }
        }
        else {
//            Utils.dismissProgress()
            self.purchaseSucessfulCallback?()
            let transactopnId = transaction.transactionIdentifier ?? ""
            let productId = self.selectedProduct ?? ""
        }
    }
    
    func purchasedCancelWithError(error: NSError?) {
        DispatchQueue.main.async {
//            Utils.dismissProgress()
            if error?.code != 2 {
                Utility.alert(message: error?.localizedDescription ?? "Unable to complete transaction. Please try again.", title: APPNAME, button1: "Ok", action: { (index: Int) in
                })
            }
        }
    }
    
    func restoreWithError(error: NSError) {
        DispatchQueue.main.async {
//            Utils.dismissProgress()
            Utility.alert(message: error.localizedDescription, title: APPNAME,button1: "Ok" ,action: { (index: Int) in
            })
        }
    }
    
    func checkUserHaveValidLicense(callback: ((_ haveValidLicense: Bool, _ data: ReceiptValidation?, _ error: Error?) -> Void)?) {
        if self.isReceiptValidationRunning {
            return
        }
        self.isReceiptValidationRunning = true
        IAPProduct.store.receiptValidation { success, data, error in
//            Utils.dismissProgress()
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
                                self.purchaseSucessfulCallback?()
                                Utility.alert(message: "Subscription purchased successfully.", title: APPNAME,button1: "Ok" ,action: { (index: Int) in
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                                
                                /*AppData.sharedInstance.profile?.isSubscriptionActive = true
                                 AppData.sharedInstance.profile?.subscriptionExpireDate = receipt.latest_receipt_info?.first?.expiresDate.timeIntervalSince1970
                                 AppData.sharedInstance.profile?.productId = receipt.latest_receipt_info?.first?.product_id
                                 AppData.sharedInstance.profile?.transactionId = receipt.latest_receipt_info?.first?.transaction_id
                                 AppData.sharedInstance.profile?.saveProfile()*/
                                callback?(true, receipt, nil)
                                return
                            }
                            else {
                                Utility.alert(message: "Subscription is expired. Please renew.", title: APPNAME,button1: "Ok" ,action: { (index: Int) in
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
