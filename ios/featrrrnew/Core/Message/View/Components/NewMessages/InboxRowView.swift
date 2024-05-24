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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.fullname ?? "")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message.text)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                Text(message.timestamp.dateValue().timestampString())
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .frame(height: 72)
    }
}

//struct InboxRowView_Previews: PreviewProvider {
    //static var previews: some View {
        //InboxRowView()
   // }
//}
