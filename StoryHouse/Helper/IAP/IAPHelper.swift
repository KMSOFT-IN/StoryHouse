//
//  IAPHelper.swift
//  SimonSays
//
//  Created by Bhautik Gadhiya on 29/09/19.
//  Copyright © 2019 KMSOFT. All rights reserved.
//

import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

public class IAPHelper : NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, SKRequestDelegate  {
    
    private let productIdentifiers: Set<ProductIdentifier>
    private var purchasedProductIdentifiers = Set<ProductIdentifier>()
    
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
    static let IAPHelperPurchaseNotification        =   "IAPHelperPurchaseNotification"
    static let IAPHelperCancelNotification          =   "IAPHelperCancelNotification"
    static let IAPHelperRestoreErrorNotification    =   "IAPHelperRestoreErrorNotification"
    static let IAPHelperRestoreNotification         =   "IAPHelperRestoreNotification"
    
    var isFromRefreshReceipt: Bool = false
    var refreshCallback: ((_ success: Bool, _ data: Any?, _ error: Error?) -> Void)?
    
    public init(productIds: Set<ProductIdentifier>) {
        self.productIdentifiers = productIds
        
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            }
            else {
                print("Not purchased: \(productIdentifier)")
            }
        }
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: - StoreKit API
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - SKProductsRequestDelegate
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        
        clearRequestAndHandler()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperRestoreErrorNotification), object: error)
    }
    
    //public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
    //    print("Restore finish...")
    //}
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        self.isFromRefreshReceipt = false
        if self.isFromRefreshReceipt {
            self.refreshCallback?(false, nil, error)
        }
        else {
            productsRequestCompletionHandler?(false, nil)
            clearRequestAndHandler()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperCancelNotification), object: error)
        }
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
    
    // MARK: - SKPaymentTransactionObserver
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                completeTransaction(transaction: transaction)
                break
            case .failed:
                failedTransaction(transaction: transaction)
                break
            case .restored:
                restoreTransaction(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                break;
            }
        }
    }
    
    private func completeTransaction(transaction: SKPaymentTransaction) {
        //guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("completeTransaction...")
        deliverPurchaseNotificatioForIdentifier(transaction: transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restoreTransaction(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        print("restoreTransaction... \(productIdentifier)")
        deliverPurchaseNotificatioForIdentifier(transaction: transaction)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func failedTransaction(transaction: SKPaymentTransaction) {
        print("failedTransaction...")
        
        if (transaction.error as NSError?)?.code != SKError.Code.paymentCancelled.rawValue {
            print("Transaction Error: \(String(describing: transaction.error?.localizedDescription))")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperCancelNotification), object: transaction.error)
    }
    
    private func deliverPurchaseNotificatioForIdentifier(transaction: SKPaymentTransaction) {
        let identifier = transaction.payment.productIdentifier
        
        purchasedProductIdentifiers.insert(identifier)
        //UserDefaults.standard.set(true, forKey: identifier)
        //UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: transaction)
    }
    
    func receiptValidation(sandBox: Bool = false, callback: ((_ success: Bool, _ data: Any?, _ error: Error?) -> Void)?) {
        //let SUBSCRIPTION_SECRET = "4709f9069c034e69ae446e8a0162bb5c" // BuddyUp Tawheed account
       // let SUBSCRIPTION_SECRET = "d2327fff847b4d578b24ca4ab3b2d0c8" // BuddyUp- K target
        let SUBSCRIPTION_SECRET = "9629d3f603654089b225df35ac19fea2" // Buddup App Stoe client
        
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do {
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch {
                print("ERROR: " + error.localizedDescription)
            }
            //let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)

            print(base64encodedReceipt!)

            let requestDictionary = ["receipt-data":base64encodedReceipt!, "password": SUBSCRIPTION_SECRET]

            guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
                let validationURLString = sandBox ? "https://sandbox.itunes.apple.com/verifyReceipt" : "https://buy.itunes.apple.com/verifyReceipt" // this works but as noted above it's best to use your own trusted server
                guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
                let session = URLSession(configuration: URLSessionConfiguration.default)
                var request = URLRequest(url: validationURL)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                    if let data = data , error == nil {
                        /*if let s = String(data: data, encoding: .utf8) {
                            Utility.logOnline(message: s, sandbox: sandBox, file: #file, function: #function, line: #line)
                        }*/
                        do {
                            let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
                            if ((appReceiptJSON as? [String: Any])?["status"] as? Int ?? 1) == 0 {
                                callback?(true, appReceiptJSON, nil)
                            }
                            else {
                                if !sandBox {
                                    self.receiptValidation(sandBox: true, callback: callback)
                                }
                                else {
                                    if !self.isFromRefreshReceipt {
                                        self.refreshReceipt(callback: callback)
                                    }
                                    else {
                                        self.isFromRefreshReceipt = false
                                        callback?(false, nil, error)
                                    }
                                }
                            }
                            print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
                            // if you are using your server this will be a json representation of whatever your server provided
                        }
                        catch let error as NSError {
                            if !sandBox {
                                self.receiptValidation(sandBox: true, callback: callback)
                            }
                            else {
                                if !self.isFromRefreshReceipt {
                                    self.refreshReceipt(callback: callback)
                                }
                                else {
                                    self.isFromRefreshReceipt = false
                                    callback?(false, nil, error)
                                }
                            }
                            print("json serialization failed with error: \(error)")
                        }
                    }
                    else {
                        callback?(false, nil, error)
                        print("the upload task returned an error: \(String(describing: error))")
                    }
                }
                task.resume()
            }
            catch let error as NSError {
                callback?(false, nil, error)
                print("json serialization failed with error: \(error)")
            }
        }
        else {
            callback?(false, nil, nil)
        }
    }
    
    private func refreshReceipt(callback: ((_ success: Bool, _ data: Any?, _ error: Error?) -> Void)?) {
        self.refreshCallback = callback
        self.isFromRefreshReceipt = true
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
        request.delegate = self
        request.start()
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        // call refresh subscriptions method again with same blocks
        if request is SKReceiptRefreshRequest {
            self.receiptValidation(sandBox: false, callback: self.refreshCallback)
            //refreshSubscriptionsStatus(callback: self.successBlock ?? {}, failure: self.failureBlock ?? {_ in})
        }
    }
    
    /*func requestDidFinish(_ request: SKRequest) {
      // call refresh subscriptions method again with same blocks
        if request is SKReceiptRefreshRequest {
            refreshSubscriptionsStatus(callback: self.successBlock ?? {}, failure: self.failureBlock ?? {_ in})
        }
    }*/
}
