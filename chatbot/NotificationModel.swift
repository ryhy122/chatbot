//
//  NotificationModel.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationModel: NSObject {
    
    let title: String
    let body: String
    let badge: NSNumber
    let id: String
    
    init(title: String, body: String, badge: NSNumber, id: String) {
        
        self.title = title
        self.body = body
        self.badge = badge
        self.id = id
        
        super.init()
    }
    
    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body  = body
        content.badge = badge
        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let requestIdentifier = id
        let request = UNNotificationRequest(identifier: requestIdentifier,content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { _ in
            print("Sent!!")
        }
    }
    
    func removeIdentifier() {
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [id])
    }
    

    
    
    
}
