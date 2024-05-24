//
//  NotificationCellViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI

@MainActor
class NotificationRowViewModel: ObservableObject {
    @Published var notification: Notification
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    init(notification: Notification) {
        self.notification = notification
    }
}
