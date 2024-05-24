//
//  ActiveNowView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/9/23.
//

import SwiftUI

struct InboxRowView: View {
    //let user: User
    let message: Message
    var body: some View {
        HStack {
            CircularProfileImageView()
            
            VStack(alignment: .leading, spacing: CGFloat.xxsm) {
                Text(message.user?.fullname ?? "")
                    .font(Style.font.messageBody)
                    .fontWeight(.semibold)
                
                Text(message.text)
                    .font(Style.font.messageCaption)
                    .foregroundColor(Color.lightBackground)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                Text(message.timestamp.dateValue().timestampString())
                
                Image(systemName: "chevron.right")
            }
            .font(Style.font.messageCaption)
            .foregroundColor(Color.lightBackground)
        }
        .padding(.horizontal)
        .frame(height: 72)
    }
}
