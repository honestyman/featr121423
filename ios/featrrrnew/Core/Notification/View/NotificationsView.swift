//
//  NotificationsView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: CGFloat.lg) {
                    ForEach($viewModel.notifications) { notification in
                        NotificationRow(notification: notification)
                            .padding(.top)
                            .onAppear {
                                if notification.id == viewModel.notifications.last?.id ?? "" {
                                    Log.i("[Future] Pagination action")
                                }
                            }
                    }
                }
                .navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
