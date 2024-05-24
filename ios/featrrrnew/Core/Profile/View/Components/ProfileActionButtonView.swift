//
//  ProfileActionButtonView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/29/23.
//

import SwiftUI

struct ProfileActionButtonView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State var showEditProfile = false
    
    var body: some View {
        VStack {
            if viewModel.user.isCurrentUser {
                Button(action: { showEditProfile.toggle() }, label: {
                    Text("Edit Profile")
                        .font(Style.font.caption)
                        .frame(width: 360, height: 32)
                        .foregroundColor(.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: .cornerS)
                                .stroke(Color.lightBackground, lineWidth: 1)
                        )
                }).fullScreenCover(isPresented: $showEditProfile) {
                    EditProfileView(user: $viewModel.user)
                }
            } else {
                VStack {
                    EmptyView()
                        
//                        NavigationLink(value: viewModel.user) {
//                            Text("Message")
//                                .font(.system(size: 14, weight: .semibold))
//                                .frame(width: 172, height: 32)
//                                .foregroundColor(Color.theme.systemBackground)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color.gray, lineWidth: 1)
//                                )
//                        }
                    
                }
            }
            
            Divider()
                .padding(.top, .xxsm)
        }
    }
}

struct ProfileActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionButtonView(viewModel: ProfileViewModel(user: dev.user))
    }
}
