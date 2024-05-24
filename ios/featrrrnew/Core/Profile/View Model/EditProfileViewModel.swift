//
//  EditProfileViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/24/23.
//


import SwiftUI
import PhotosUI
import FirebaseFirestoreSwift
import Firebase

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var uploadComplete = false
    @Published var selectedImages: [PhotosPickerItem] = [] {
        didSet {
            
                Task {
                    imageItems = await ImageCarouselItem.arrayWithItems(selectedImages)
                } //TODO: Will upload duplicates (possibly delete old profile images)
            
        }
    }
    @Published var imageItems: [ImageCarouselItem] = []
    
    var fullname = ""
    var bio = ""
                
    init(user: User) {
        self.user = user
        
        if let bio = user.bio {
            self.bio = bio
        }
        
        if let fullname = user.fullname {
            self.fullname = fullname
        }
    }
    
    
    func updateUserData() async throws {
        var data: [String: Any] = [:]

        do {
            let imageUrls = try await ImageUploadService.standard.uploadImages(imageItems: imageItems)
            
            guard let safeImageUrls = imageUrls else {
                
                Log.c("Image URLs were not set; probably an API issue.  Terminating early")
                return
            }
            
            data["profileImageUrls"] = safeImageUrls
            
        } catch {
            Log.c("An error was thrown while uploading the images - \(error.localizedDescription)")
        }
            
        
        if !fullname.isEmpty, user.fullname ?? "" != fullname {
            user.fullname = fullname
            data["fullname"] = fullname
        }
        
        if !bio.isEmpty, user.bio ?? "" != bio {
            user.bio = bio
            data["bio"] = bio
        }
        
        try await COLLECTION_USERS.document(user.id).updateData(data)
    }
}
