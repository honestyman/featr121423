//
//  UploadJobViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/10/23.
//

//import Foundation
import PhotosUI
import SwiftUI
import Firebase
import StripePaymentSheet

class UploadJobViewModel: ModifyJobViewModel {
    func uploadJob() async throws -> Bool {
        
        guard let uid = Auth.auth().currentUser?.uid else { return false  }
        if imageItems.count <= 0 { return false }
        self.setIsUploading(true)
        do {
            let imageUrls = try await ImageUploadService.standard.uploadImages(imageItems: imageItems)
            
            guard let safeImageUrls = imageUrls else {
                
                Log.c("Image URLs were not set; probably an API issue.  Terminating early")
                self.setIsUploading(false)
                return false
            }
            var data: [String: Any] = [
                "jobBio": jobBio,
                "category": category,
                "city": city,
                "state": state,
                "country": country,
                "timestamp": Timestamp(date: Date()),
                "imageUrls": safeImageUrls,
                "ownerUid": uid
            ]
            
            if let hr {
                data["hr"] = hr
            }
            if let task {
                data["task"] = task
            }
            
            if let storyPost {
                data["storyPost"] = storyPost
            }
            
            self.clearData()
            
            let _ = try await COLLECTION_JOBS.addDocument(data: data)
            self.setIsUploading(false)
            return true
        } catch {
            Log.d("Failed to upload image with error \(error.localizedDescription)")
            self.error = error
            self.setIsUploading(false)
            return false
        }
    }
}



