//
//  ProfileHeaderView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI
import Kingfisher


struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView{
            VStack {
                
                    ImageCarousel(urls: viewModel.user.profileImageUrls)
                        .threeFour()
                        
                VStack(alignment: .leading, spacing: CGFloat.xxsm) {
                    if let fullname = viewModel.user.fullname {
                        Text(fullname)
                            .font(Style.font.caption)
                            .padding(.leading)
                    }
                    
                    if let bio = viewModel.user.bio {
                        Text(bio)
                            .font(Style.font.body2)
                            .padding(.leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ProfileActionButtonView(viewModel: viewModel)
                    .padding()
            }
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(viewModel: ProfileViewModel(user: dev.user))
            .background(Color.primary)
    }
}
/*import SwiftUI

struct ProfileHeaderView: View {
    
    let user: User
    @State private var showEditProfile = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack{
                    /*Image(user.profileImageUrl ?? "")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: 400)*/
                    RoundedRectangleView(user: user)
                    
                    
                    
                    
                    
                }
                
                Text("@\(user.username)")
                    .padding(.top, 30)
                
                Button {
                    if user.isCurrentUser {
                        showEditProfile.toggle()
                    }
                } label: {
                    Text(user.isCurrentUser ? "Edit Profile": "")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame( width: 360, height: 32)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 6)
                            .stroke(user.isCurrentUser ? Color.gray : .clear, lineWidth: 1))
                }
                .padding()
                
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            EditProfileView(user: user)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(user: User.MOCK_USERS[0])
    }
}*/
