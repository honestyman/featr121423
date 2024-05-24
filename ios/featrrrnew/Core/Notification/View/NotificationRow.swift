//
//  NotificationCell.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI
import Kingfisher

struct NotificationRow: View {
    @ObservedObject var viewModel: NotificationRowViewModel
    @Binding var notification: Notification
    
   
    
    init(notification: Binding<Notification>) {
        self.viewModel = NotificationRowViewModel(notification: notification.wrappedValue)
        self._notification = notification
    }
    
    var body: some View {
        HStack {
            if let user = notification.user {
                NavigationLink(destination: ProfileView(user: user)) {
                    CircularProfileImageView(user: user)
                    
                    HStack {
                        Text(user.username)
                            .font(Style.font.caption) +
                        
                        Text(notification.type.notificationMessage)
                            .font(Style.font.body) +
                        
                        Text(" \(viewModel.timestampString)")
                            .foregroundColor(Color.lightBackground).font(Style.font.body2)
                    }
                    .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
        }
    
    }
}
