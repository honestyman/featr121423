//
//  SwiftUIView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/27/23.
//

import SwiftUI
import Kingfisher

struct MainTabView: View {
    let user: User
    @Binding var selectedIndex: Int
    @State private var imagePreviewUrl: String?
    @State private var imagePreviewUrls: [String]?
    @State private var imageProfilePreview: Bool = false
    //@State private var selectedIndex = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                //NavigationStack {
                JobView()
                    .onAppear {
                        selectedIndex = 0
                    }
                    .tabItem{
                        Image(systemName: "house")
                        
                    }
                    .tag(0)

                PaymentView()
                    .onAppear {
                        selectedIndex = 1
                    }
                    .tabItem{
                        Image(systemName: "creditcard")
                    }
                    .tag(1)
                
                CalendarView(interval: DateInterval(start: .now, end: .distantFuture))
                    .onAppear {
                        selectedIndex = 2
                    }
                    .tabItem{
                        Image(systemName: "calendar")
                    }
                    .tag(2)
                
                InboxView()
                    .onAppear {
                        selectedIndex = 3
                    }
                    .tabItem{
                        Image(systemName: "message")
                    }
                    .tag(3)
                
                CurrentUserProfileView(user: user)
                    .onAppear {
                        selectedIndex = 4
                    }
                    .tabItem{
                        Image(systemName: "person")
                    }
                    .tag(4)
                
            }.onReceive(NotificationCenter.default.publisher(for: NSNotification.PhotoTap)) { output in
                if let imageUrlObj = output.object as? String {
                    imagePreviewUrl = imageUrlObj
                } else if let imageUrlObj = output.object as? [String] {
                    imagePreviewUrls = imageUrlObj
                } else {
                    imagePreviewUrl = nil
                    imagePreviewUrls = nil
                }
                
            }
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.ProfilePhotoTap)) { output in
                if let imageUrlObj = output.object as? [String] {
                    imageProfilePreview = true
                    imagePreviewUrls = imageUrlObj
                } else {
                    imagePreviewUrl = nil
                    imagePreviewUrls = nil
                }
                
            }
            withAnimation(.spring()) {
                ImagePreviewView(previewImageUrl: $imagePreviewUrl)
            }
            withAnimation(.spring()) {
                CarouselImagePreview(previewImageUrls: $imagePreviewUrls, imageProfilePreview: $imageProfilePreview)
            }
        }
    }
}
