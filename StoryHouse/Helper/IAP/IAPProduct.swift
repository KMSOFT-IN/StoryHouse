//
//  IAPProduct.swift
//  SimonSays
//
//  Created by Bhautik Gadhiya on 29/09/19.
//  Copyright © 2019 KMSOFT. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPProductDelegate {
    func getProductList(productList: [SKProduct]);
    func purchasedProductListWithIndex(transaction: SKPaymentTransaction, productList: [SKProduct], index: [Int]);
    func purchasedCancelWithError(error: NSError?);
    func restoreWithError(error: NSError);
}

public class IAPProduct {
    
    private static var productIdentifiers: Set<String> = []
    public static let store = IAPHelper(productIds: IAPProduct.productIdentifiers)
    
    var delegate : IAPProductDelegate?;
    
    static func setProductIndentifiers(productList: [String]) {
        for productId in productList {
            IAPProduct.productIdentifiers.insert(productId)
        }
    }
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    func purchaseProduct(product: SKProduct) {
        IAPProduct.store.buyProduct(product: product)
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(IAPProduct.handlePurchaseNotification(notification:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IAPProduct.handleCancelNotification(notification:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperCancelNotification),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(IAPProduct.handleRestoreNotification(notification:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperRestoreErrorNotification),
                                               object: nil)
    }
    
    public static var productList: [SKProduct] = []
    
    func loadProdictList(callback: (() -> Void)? = nil) {
        if(IAPProduct.productList.count == 0) {
            IAPProduct.store.requestProducts{success, products in
                IAPProduct.productList = []
                if success {
                    IAPProduct.productList = products!
                }
                callback?()
                self.delegate?.getProductList(productList: IAPProduct.productList)
            }
        }
        else {
            callback?()
            self.delegate?.getProductList(productList: IAPProduct.productList)
        }
    }
    
    func restorePurchase() {
        IAPProduct.store.restorePurchases()
    }
    
    @objc func handleCancelNotification(notification: NSNotification) {
        self.delegate?.purchasedCancelWithError(error: notification.object as? NSError)
    }
    
    @objc func handleRestoreNotification(notification: NSNotification) {
        self.delegate?.restoreWithError(error: notification.object as! NSError)
    }
    
    @objc func handlePurchaseNotification(notification: NSNotification) {
        guard let transaction = notification.object as? SKPaymentTransaction else { return }
        let productID = transaction.payment.productIdentifier
        var purchasedProductList: [SKProduct] = []
        var purchasedProductIndexes: [Int] = []
        for (index, product) in IAPProduct.productList.enumerated() {
            guard product.productIdentifier == productID else { continue }
            purchasedProductList.append(product)
            purchasedProductIndexes.append(index)
        }
        self.delegate?.purchasedProductListWithIndex(transaction: transaction, productList: purchasedProductList, index: purchasedProductIndexes)
    }
}

func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
