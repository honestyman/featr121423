//
//  ImageUploader.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/24/23.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFAudio

enum AudioError: Error {
    case fileMissing, malformedData, general(String)
}
struct AudioUploadService {
    
    public static let standard = AudioUploadService()
    
    private let audioUrlPath = "message_audio"
    
    func uploadAudio(localURL path: URL) async throws -> String? {
        let filename = NSUUID().uuidString
        let audioDBPath = Storage.storage().reference(withPath: "/\(audioUrlPath)/\(filename).m4a")

        
        if !FileManager.default.fileExists(atPath: path.path()) {
            Log.d("The provided path does not exist")
            throw AudioError.fileMissing
        }
        guard let data = try? Data(contentsOf:path) else {
            Log.d("Encrypting the audio path into data failed")
            throw AudioError.malformedData
        }
        
        do {
            let _ = try await audioDBPath.putDataAsync(data)
            let url = try await audioDBPath.downloadURL()
            return url.absoluteString
        } catch {
            Log.d("Failed to upload audio \(error.localizedDescription)")
            return nil
        }
    }
}
