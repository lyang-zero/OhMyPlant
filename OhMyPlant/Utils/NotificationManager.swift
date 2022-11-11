//
//  NotificationManager.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-20.
//

import Foundation
import UserNotifications
import SwiftUI

enum NotificationType {
    case water, fertilize
}

final class NotificationManager {
    @AppStorage("notification") static private var notification = true
    /// - Parameters:
    ///     - plantId: Used for identify notification request
    ///     - timeInterval: per days
    static func update(plantId: String, timeInterval: Int, title: String, notificationType: NotificationType) {
        guard notification else {return}
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(plantId)+water", "\(plantId)+fertilize"])
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.subtitle = notificationType == .water ? "Your plant need water!" : "Your plant need food!"
                content.sound = UNNotificationSound.default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval*24*60*60), repeats: false)

                let request = UNNotificationRequest(identifier: "\(plantId)+\(notificationType == .water ? "water" : "fertilize")", content: content, trigger: trigger)

                // add our notification request
                UNUserNotificationCenter.current().add(request)
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
