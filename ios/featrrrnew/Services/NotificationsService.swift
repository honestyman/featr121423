//
//  NotificationsManager.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/12/23.
//

import Foundation
import UserNotifications

class NotificationsService: ObservableObject {
    @Published private(set) var hasPermission = false
    
    init() {
        Task {
            await getAuthStatus()
        }
    }
    
    func request() async {
        do {
            self.hasPermission = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            Log.i(error.localizedDescription)
        }
    }
    
    func getAuthStatus() async {
        let status = await UNUserNotificationCenter.current().notificationSettings()
        switch status.authorizationStatus {
        case.authorized,
                .provisional,
                .ephemeral:
            hasPermission = true
        default:
            hasPermission = true
        }
    }
}
