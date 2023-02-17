//
//  NotificationHandler.swift
//  BuddyUp
//
//  Created by KMSOFT on 29/03/2022.
//

import Foundation
import UIKit

protocol NotificationHandler {
    func handle(notification: [AnyHashable: Any], appState: UIApplication.State) -> Bool
}

class AppNotificationHandler: NotificationHandler {

    func handle(notification userInfo: [AnyHashable: Any], appState: UIApplication.State) -> Bool {

        return true
    }
}
