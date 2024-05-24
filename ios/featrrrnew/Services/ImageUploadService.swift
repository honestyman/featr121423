//
//  ImageUploader.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/24/23.
//

import UIKit
import Firebase
import FirebaseStorage

enum UploadType {
    case profile
    case job
    case message
    
    var filePath: StorageReference {
        let filename = NSUUID().uuidString
        switch self {
        case .profile:
            return Storage.storage().reference(withPath: "/profile_images/\(filename)")
        case .job:
            return Storage.storage().reference(withPath: "/job_images/\(filename)")
        case .message:
            return Storage.storage().reference(withPath: "/message_images/\(filename)")
        }
    }
}

struct ImageUploadService {
    
    static let standard = ImageUploadService()
    
    func uploadImage(image: UIImage, type: UploadType) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return nil }
        let ref = type.filePath
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            Log.d("Failed to upload image \(error.localizedDescription)")
            return nil
        }
    }
    
    func uploadImages(imageItems: [ImageCarouselItem]) async throws -> [String]?{
        return await withTaskGroup(of: String?.self, returning: [String]?.self) { taskGroup in
            var imageUrls: [String] = []
            for url in imageItems {
                if let image = url.image {
                   
                        taskGroup.addTask {
                            do {
                                if let imageUrl = try await ImageUploadService.standard.uploadImage(image: image, type: .job) {
                                    return imageUrl
                                } else {
                                    Log.d("Unable to get the image Url because it wasn't returned from the ImageUploader")
                                    return nil
                                }
                            } catch {
                                Log.d("An error was thrown whenever the image was uploading: \(error.localizedDescription)")
                                return nil
                            }
                        }
                }
            }
            for await image in taskGroup {
                if let imageURL = image {
                    imageUrls.append(imageURL)
                }
            }
            return imageUrls.reversed()
        }
    }
}
