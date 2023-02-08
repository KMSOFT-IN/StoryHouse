//
//  ReceiptValidation.swift
//  StoryHouse
//
//  Created by iMac on 08/02/23.
//

import Foundation

class ReceiptValidation {
    var environment: String?
    var receipt: Receipt?
    var pending_renewal_info: [PendingRenewalInfo]?
    var status: Int?
    var latest_receipt_info: [ReceiptInfo]?
    var latest_receipt: String?
    
    init(environment: String,
         receipt: Receipt,
         pending_renewal_info: [PendingRenewalInfo],
         status: Int,
         latest_receipt_info: [ReceiptInfo],
         latest_receipt: String) {
        self.environment = environment
        self.receipt = receipt
        self.pending_renewal_info = pending_renewal_info
        self.status = status
        self.latest_receipt_info = latest_receipt_info
        self.latest_receipt = latest_receipt
    }
    
    init(dictionary: [String: Any]) {
        self.environment = dictionary["environment"] as? String
        if let receiptDictionary = dictionary["receipt"] as? [String: Any] {
            self.receipt = Receipt.getInstance(dictionary: receiptDictionary)
        }
        if let pendingRenewalInfo = dictionary["pending_renewal_info"] as? [[String: Any]] {
            self.pending_renewal_info = PendingRenewalInfo.getArrayList(array: pendingRenewalInfo)
        }
        self.status = dictionary["status"] as? Int
        if let latestReceiptInfo = dictionary["latest_receipt_info"] as? [[String: Any]] {
            self.latest_receipt_info = ReceiptInfo.getArrayList(array: latestReceiptInfo)
        }
        self.latest_receipt = dictionary["latest_receipt"] as? String
    }
    
    class func getInstance(dictionary: [String:Any]) -> ReceiptValidation? {
        let response = ReceiptValidation(dictionary: dictionary)
        return response
    }
    
    class func getArrayList(array: [[String: Any]]) -> [ReceiptValidation]? {
        var arrayList : [ReceiptValidation] = []
        for obj in array {
            let response = ReceiptValidation(dictionary: obj)
            arrayList.append(response)
        }
        return arrayList
    }
}

class Receipt {
    var adam_id: Int?
    var app_item_id: Int?
    var application_version: String?
    var bundle_id:  String?
    var download_id: Int?
    var in_app: [ReceiptInfo]?
    var original_application_version: String?
    var original_purchase_date: String?
    var original_purchase_date_ms: String?
    var original_purchase_date_pst: String?
    var receipt_creation_date: String?
    var receipt_creation_date_ms: String?
    var receipt_creation_date_pst: String?
    var receipt_type: String?
    var request_date: String?
    var request_date_ms: String?
    var request_date_pst: String?
    var version_external_identifier: Int?
    
    init(adam_id: Int,
         app_item_id: Int,
         application_version: String,
         bundle_id: String,
         download_id: Int,
         in_app: [ReceiptInfo],
         original_application_version: String,
         original_purchase_date: String,
         original_purchase_date_ms: String,
         original_purchase_date_pst: String,
         receipt_creation_date: String,
         receipt_creation_date_ms: String,
         receipt_creation_date_pst: String,
         receipt_type: String,
         request_date: String,
         request_date_ms: String,
         request_date_pst: String,
         version_external_identifier: Int) {
        self.adam_id = adam_id
        self.app_item_id = app_item_id
        self.application_version = application_version
        self.bundle_id = bundle_id
        self.download_id = download_id
        self.in_app = in_app
        self.original_application_version = original_application_version
        self.original_purchase_date = original_purchase_date
        self.original_purchase_date_ms = original_purchase_date_ms
        self.original_purchase_date_pst = original_purchase_date_pst
        self.receipt_creation_date = receipt_creation_date
        self.receipt_creation_date_ms = receipt_creation_date_ms
        self.receipt_creation_date_pst = receipt_creation_date_pst
        self.receipt_type = receipt_type
        self.request_date = request_date
        self.request_date_ms = request_date_ms
        self.request_date_pst = request_date_pst
        self.version_external_identifier = version_external_identifier
    }
    
    init(dictionary: [String: Any]) {
        self.adam_id = dictionary["adam_id"] as? Int
        self.app_item_id = dictionary["app_item_id"] as? Int
        self.application_version = dictionary["application_version"] as? String
        self.bundle_id = dictionary["bundle_id"] as? String
        self.download_id = dictionary["download_id"] as? Int
        if let inApp = dictionary["in_app"] as? [[String: Any]] {
            self.in_app = ReceiptInfo.getArrayList(array: inApp)
        }
        self.original_application_version = dictionary["original_application_version"] as? String
        self.original_purchase_date = dictionary["original_purchase_date"] as? String
        self.original_purchase_date_ms = dictionary["original_purchase_date_ms"] as? String
        self.original_purchase_date_pst = dictionary["original_purchase_date_pst"] as? String
        self.receipt_creation_date = dictionary["receipt_creation_date"] as? String
        self.receipt_creation_date_ms = dictionary["receipt_creation_date_ms"] as? String
        self.receipt_creation_date_pst = dictionary["receipt_creation_date_pst"] as? String
        self.receipt_type = dictionary["receipt_type"] as? String
        self.request_date = dictionary["request_date"] as? String
        self.request_date_ms = dictionary["request_date_ms"] as? String
        self.request_date_pst = dictionary["request_date_pst"] as? String
        self.version_external_identifier = dictionary["version_external_identifier"] as? Int
        
    }
    
    class func getInstance(dictionary: [String:Any]) -> Receipt? {
        let response = Receipt(dictionary: dictionary)
        return response
    }
    
    class func getArrayList(array: [[String: Any]]) -> [Receipt]? {
        var arrayList : [Receipt] = []
        for obj in array {
            let response = Receipt(dictionary: obj)
            arrayList.append(response)
        }
        return arrayList
    }
}

class ReceiptInfo {
    var expires_date: String?
    var expires_date_ms: String?
    var expires_date_pst: String?
    var in_app_ownership_type: String?
    var is_in_intro_offer_period: String?
    var is_trial_period: String?
    var original_purchase_date: String?
    var original_purchase_date_ms: String?
    var original_purchase_date_pst: String?
    var original_transaction_id: String?
    var product_id: String?
    var purchase_date: String?
    var purchase_date_ms: String?
    var purchase_date_pst: String?
    var quantity: String?
    var subscription_group_identifier: String?
    var transaction_id: String?
    var web_order_line_item_id: String?
    
    var expiresDate: Date {
        get {
            return Date(timeIntervalSince1970: (Double(self.expires_date_ms ?? "0")! / 1000))
        }
    }
    
    init(expires_date: String,
         expires_date_ms: String,
         expires_date_pst: String,
         in_app_ownership_type: String,
         is_in_intro_offer_period: String,
         is_trial_period: String,
         original_purchase_date: String,
         original_purchase_date_ms: String,
         original_purchase_date_pst: String,
         original_transaction_id: String,
         product_id: String,
         purchase_date: String,
         purchase_date_ms: String,
         purchase_date_pst: String,
         quantity: String,
         subscription_group_identifier: String,
         transaction_id: String,
         web_order_line_item_id: String) {
        self.expires_date = expires_date
        self.expires_date_ms = expires_date_ms
        self.expires_date_pst = expires_date_pst
        self.in_app_ownership_type = in_app_ownership_type
        self.is_in_intro_offer_period = is_in_intro_offer_period
        self.is_trial_period = is_trial_period
        self.original_purchase_date = original_purchase_date
        self.original_purchase_date_ms = original_purchase_date_ms
        self.original_purchase_date_pst = original_purchase_date_pst
        self.original_transaction_id = original_transaction_id
        self.product_id = product_id
        self.purchase_date = purchase_date
        self.purchase_date_ms = purchase_date_ms
        self.purchase_date_pst = purchase_date_pst
        self.quantity = quantity
        self.subscription_group_identifier = subscription_group_identifier
        self.transaction_id = transaction_id
        self.web_order_line_item_id = web_order_line_item_id
    }
    
    init(dictionary: [String: Any]) {
        self.expires_date = dictionary["expires_date"] as? String
        self.expires_date_ms = dictionary["expires_date_ms"] as? String
        self.expires_date_pst = dictionary["expires_date_pst"] as? String
        self.in_app_ownership_type = dictionary["in_app_ownership_type"] as? String
        self.is_in_intro_offer_period = dictionary["is_in_intro_offer_period"] as? String
        self.is_trial_period = dictionary["is_trial_period"] as? String
        self.original_purchase_date = dictionary["original_purchase_date"] as? String
        self.original_purchase_date_ms = dictionary["original_purchase_date_ms"] as? String
        self.original_purchase_date_pst = dictionary["original_purchase_date_pst"] as? String
        self.original_transaction_id = dictionary["original_transaction_id"] as? String
        self.product_id = dictionary["product_id"] as? String
        self.purchase_date = dictionary["purchase_date"] as? String
        self.purchase_date_ms = dictionary["purchase_date_ms"] as? String
        self.purchase_date_pst = dictionary["purchase_date_pst"] as? String
        self.quantity = dictionary["quantity"] as? String
        self.subscription_group_identifier = dictionary["subscription_group_identifier"] as? String
        self.transaction_id = dictionary["transaction_id"] as? String
        self.web_order_line_item_id = dictionary["web_order_line_item_id"] as? String
    }
    
    class func getInstance(dictionary: [String:Any]) -> ReceiptInfo? {
        let response = ReceiptInfo(dictionary: dictionary)
        return response
    }
    
    class func getArrayList(array: [[String: Any]]) -> [ReceiptInfo]? {
        var arrayList : [ReceiptInfo] = []
        for obj in array {
            let response = ReceiptInfo(dictionary: obj)
            arrayList.append(response)
        }
        return arrayList
    }
}

class PendingRenewalInfo {
    var auto_renew_product_id: String?
    var auto_renew_status:  String?
    var expiration_intent: String?
    var is_in_billing_retry_period: String?
    var original_transaction_id: String?
    var product_id: String?
    
    init(auto_renew_product_id: String,
         auto_renew_status: String,
         expiration_intent: String,
         is_in_billing_retry_period: String,
         original_transaction_id: String,
         product_id: String) {
        self.auto_renew_product_id = auto_renew_product_id
        self.auto_renew_status = auto_renew_status
        self.expiration_intent = expiration_intent
        self.is_in_billing_retry_period = is_in_billing_retry_period
        self.original_transaction_id = original_transaction_id
        self.product_id = product_id
    }
    
    init(dictionary: [String: Any]) {
        self.auto_renew_product_id = dictionary["auto_renew_product_id"] as? String
        self.auto_renew_status = dictionary["auto_renew_status"] as? String
        self.expiration_intent = dictionary["expiration_intent"] as? String
        self.is_in_billing_retry_period = dictionary["is_in_billing_retry_period"] as? String
        self.original_transaction_id = dictionary["original_transaction_id"] as? String
        self.product_id = dictionary["product_id"] as? String
    }
    
    class func getInstance(dictionary: [String:Any]) -> PendingRenewalInfo? {
        let response = PendingRenewalInfo(dictionary: dictionary)
        return response
    }
    
    class func getArrayList(array: [[String: Any]]) -> [PendingRenewalInfo]? {
        var arrayList : [PendingRenewalInfo] = []
        for obj in array {
            let response = PendingRenewalInfo(dictionary: obj)
            arrayList.append(response)
        }
        return arrayList
    }
}
