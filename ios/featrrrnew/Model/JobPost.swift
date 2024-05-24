//
//  Job.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import FirebaseFirestoreSwift
import Firebase

enum JobStatus {
    case none, pending, cancelled, hired
}
struct JobPost: Identifiable, Hashable, Decodable {
    
    @DocumentID var id: String?
    
    let ownerUid: String
    let jobBio: String
    var rating: Int?
    let imageUrls: [String]
    let timestamp: Timestamp
    let hr: Int
    let task: Int
    let storyPost: Int
    let city: String
    let state: String
    let country: String
    let category: String
    let paidUsers: [String]?
    let refundRequestedUsers: [String]?
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerUid
        case jobBio
        case rating
        case imageUrl
        case imageUrls
        case timestamp
        case hr
        case task
        case storyPost
        case city
        case state
        case country
        case category
        case paidUsers
        case refundRequestedUsers
        case user
    }
    
    init(id: String? = nil,
            ownerUid: String,
            jobBio: String,
            rating: Int? = nil,
            imageUrls: [String],
            timestamp: Timestamp,
            hr: Int,
            task: Int,
            storyPost: Int,
            city: String,
            state: String,
            country: String,
            category: String,
            paidUsers: [String]? = nil,
            refundRequestedUsers: [String]? = nil,
            user: User? = nil) {
           
           self.id = id
           self.ownerUid = ownerUid
           self.jobBio = jobBio
           self.rating = rating
           self.imageUrls = imageUrls
           self.timestamp = timestamp
           self.hr = hr
           self.task = task
           self.storyPost = storyPost
           self.city = city
           self.state = state
           self.country = country
           self.category = category
           self.paidUsers = paidUsers
           self.refundRequestedUsers = refundRequestedUsers
           self.user = user
       }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try container.decode(DocumentID<String>.self, forKey: .id)
        ownerUid = try container.decode(String.self, forKey: .ownerUid)
        jobBio = try container.decode(String.self, forKey: .jobBio)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        
        /// Note - Eventually this will ideally just be flattened into an array and not a seperate value – however, it is written this way to maintain backwards compatability
        let url = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        let urls = try container.decodeIfPresent([String].self, forKey: .imageUrls)
        if let urls = urls {
            imageUrls = urls
        } else if let url = url {
            imageUrls = [url]
        } else {
            Log.c("There was no image URL(s) available for the expected keys")
            imageUrls = []
        }
        timestamp = try container.decode(Timestamp.self, forKey: .timestamp)
        hr = try container.decode(Int.self, forKey: .hr)
        task = try container.decode(Int.self, forKey: .task)
        storyPost = try container.decode(Int.self, forKey: .storyPost)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        category = try container.decode(String.self, forKey: .category)
        paidUsers = try container.decodeIfPresent([String].self, forKey: .paidUsers)
        refundRequestedUsers = try container.decodeIfPresent([String].self, forKey: .refundRequestedUsers)
        user = try container.decodeIfPresent(User.self, forKey: .user)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(ownerUid, forKey: .ownerUid)
        try container.encode(jobBio, forKey: .jobBio)
        try container.encodeIfPresent(rating, forKey: .rating)
        
        /// Note - Eventually this will ideally just be flattened into an array and not a seperate value – however, it is written this way to maintain backwards compatability
        if imageUrls.count <= 1 {
            if let firstImageUrl = imageUrls.first {
                try container.encode(firstImageUrl, forKey: .imageUrl)
            }
        }else {
            try container.encode(imageUrls, forKey: .imageUrls)
        }
        
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(hr, forKey: .hr)
        try container.encode(task, forKey: .task)
        try container.encode(storyPost, forKey: .storyPost)
        try container.encode(city, forKey: .city)
        try container.encode(state, forKey: .state)
        try container.encode(country, forKey: .country)
        try container.encode(category, forKey: .category)
        try container.encodeIfPresent(paidUsers, forKey: .paidUsers)
        try container.encodeIfPresent(refundRequestedUsers, forKey: .refundRequestedUsers)
        try container.encodeIfPresent(user, forKey: .user)
    }
}
