//
//  ProfileHeaderView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI
import Kingfisher


struct MinifiedProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView{
            HStack {
                
                Button(action: {
                    NotificationCenter.default.post(name: NSNotification.ProfilePhotoTap, object: viewModel.user.profileImageUrls, userInfo: nil)
                }) {
                    ImageCarousel(urls: viewModel.user.profileImageUrls, padding: EdgeInsets.init(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .minifiedThreeFour()
                }
                
                VStack(alignment: .leading, spacing: CGFloat.xxsm) {
                    
                    
                    Chip(text: "@\(viewModel.user.username)", style: .information)
                    
                    
                    if let fullname = viewModel.user.fullname {
                        Text(fullname)
                            .font(Style.font.title3)
                            .fontWeight(.semibold)
                        
                    }
                    
                    if let bio = viewModel.user.bio {
                        Text(bio)
                            .font(Style.font.caption)
                        
                        //TODO: View Profile
                    }
                    
                    //                    ProfileActionButtonView(viewModel: viewModel)
                    //                        .padding()
                }
                .padding(.leading)
                
                
            }
        }
    }
}

struct MinifiedProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MinifiedProfileHeaderView(viewModel: ProfileViewModel(user: dev.user))
            .background(Color.primary)
    }
}
