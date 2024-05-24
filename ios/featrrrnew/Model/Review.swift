//
//  Reviews.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Review: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let jobOwnerUid: String
    let profileImageUrl: String
    let reviewText: String
    let jobId: String
    let timestamp: Timestamp
    let reviewOwnerUid: String
    
    init(user: User, data: [String: Any]) {
        self.username = user.username
        self.profileImageUrl = user.profileImageUrls.first ?? ""
        self.jobOwnerUid = data["jobOwnerUid"] as? String ?? ""
        self.reviewText = data["reviewText"] as? String ?? ""
        self.jobId = data["jobId"] as? String ?? ""
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
        self.reviewOwnerUid = data["reviewOwnerUid"] as? String ?? ""
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
}
