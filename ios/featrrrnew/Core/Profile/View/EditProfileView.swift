//
//  EditProfileView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/24/23.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct EditProfileView: View {
    @State private var username = ""

    @StateObject private var viewModel: EditProfileViewModel
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    
    init(user: Binding<User>) {
        self._user = user
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user.wrappedValue))
        self._username = State(initialValue: _user.wrappedValue.username)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Text("Edit Profile")
                    .font(Style.font.title)
                    .foregroundColor(.background)
                
                Spacer()
                
                Button {
                    Task {
                        try await viewModel.updateUserData()
                        dismiss()
                    }
                } label: {
                    Text("Done")
                        .bold()
                }
            }
            .padding(.horizontal,.sm)
            
            VStack(spacing: CGFloat.sm) {
                Divider()
                
//                messageText.isEmpty {
//                    PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: MAX_PHOTOS, selectionBehavior: .ordered, matching: .any(of: [.screenshots, .livePhotos, .images, .depthEffectPhotos])) {
                
                PhotosPicker(selection: $viewModel.selectedImages, matching: .any(of: [.screenshots, .livePhotos, .images, .depthEffectPhotos])) {
                        VStack {
                            if viewModel.imageItems.count > 0 {
                                ImageCarousel(carouselItems: $viewModel.imageItems)
                                    .addPlaceholder(noContent: Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 370, height: 350)
                                        .clipShape(RoundedRectangle(cornerRadius: .cornerS))
                                        .foregroundColor(Color.lightBackground))
                            } else {
//                                RoundedRectangleView(user: viewModel.user)
                            }
                            Text("Edit profile picture")
                                .font(Style.font.caption)
                        }
                    }
                .padding(.vertical, .sm)
                
                Divider()
            }
            .padding(.bottom, .xxsm)
            
            VStack {
                EditProfileRowView(title: "Name", placeholder: "Enter your name..", text: $viewModel.fullname)
                
                EditProfileRowView(title: "Bio", placeholder: "Enter your bio..", text: $viewModel.bio)
            }
            
            Spacer()
        }
        .onReceive(viewModel.$user, perform: { user in
            self.user = user
        })
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        HStack {
            Text(title)
                .padding(.leading, .sm)
                .frame(width: 100, alignment: .leading)
                            
            VStack {
                TextField(placeholder, text: $text)
                Divider()
            }
        }
        .frame(height: 36)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .constant(dev.user))
    }
}
