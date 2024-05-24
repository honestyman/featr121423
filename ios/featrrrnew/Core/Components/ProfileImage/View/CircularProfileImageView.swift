//
//  CircularProfileImageView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/24/23.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    //let user: User
    var user: User?
    var body: some View {
        VStack {
            if let imageUrl = user?.profileImageUrls.first {
                NavigationLink(value: user) {
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                
            }  else {
                NavigationLink(value: user) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .foregroundColor(Color.lightBackground)
                }
                
            }
        }
        .navigationDestination(for: User.self, destination: { user in
            ProfileView(user: user)
        })
            
    }
}

struct CircularProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProfileImageView(user: dev.user)
    }
}
