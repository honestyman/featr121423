//
//  User.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase


// Regenerated with help from ChatGPT 3.5
struct User: Identifiable, Codable {
    
    @DocumentID var uid: String?
    
    var username: String
    let email: String
    var profileImageUrls: [String] = []
    var fullname: String?
    var bio: String?
    var isFollowed: Bool? = false
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
    var id: String { return uid ?? UUID().uuidString }

    enum CodingKeys: String, CodingKey {
        case uid
        case username
        case email
        case profileImageUrls
        case profileImageUrl //Backwards compatability with single image
        case fullname
        case bio
        case isFollowed
    }
    
    init(uid: String?, username: String, email: String, profileImageUrls: [String] = [], fullname: String? = nil, bio: String? = nil, isFollowed: Bool? = nil) {
        
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImageUrls = profileImageUrls
        self.fullname = fullname
        self.bio = bio
        self.isFollowed = isFollowed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        _uid = try container.decode(DocumentID<String>.self, forKey: .uid)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        
        // Read the image URL!s! first instead of the image URL if it's in use
        if let imageUrls = try container.decodeIfPresent([String].self, forKey: .profileImageUrls) {
            profileImageUrls = imageUrls
        } else if let imageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl) {
            profileImageUrls = [imageUrl]
        } else {
            profileImageUrls = []
        }
        fullname = try container.decodeIfPresent(String.self, forKey: .fullname)
        bio = try container.decodeIfPresent(String.self, forKey: .bio)
        isFollowed = try container.decodeIfPresent(Bool.self, forKey: .isFollowed) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(uid, forKey: .uid)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(profileImageUrls, forKey: .profileImageUrls)
        try container.encodeIfPresent(fullname, forKey: .fullname)
        try container.encodeIfPresent(bio, forKey: .bio)
        try container.encodeIfPresent(isFollowed, forKey: .isFollowed)
    }
}

extension User: Hashable {
    var identifier: String { return id }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
