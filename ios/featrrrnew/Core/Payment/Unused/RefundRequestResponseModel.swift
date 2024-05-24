//
//  RefundRequestResponseModel.swift
//  SwiftUIProject
//
//  Created by CodistanVentures on 10/31/23.
//

import Foundation


struct RefundRequestDTO: Codable {
    let success: Bool
    let message: String
    let refundRequests: [RefundRequest]?
}


struct RefundRequest: Codable,Identifiable {
    let id: String
    let status: RefundStatus
    let job: RefundJob

    enum CodingKeys: String, CodingKey {
        case id
        case status, job
    }
}

enum RefundStatus: String,Codable{
    case pending = "pending"
    case completed = "completed"
}

struct RefundJob: Codable {
    let country, city, jobBio: String
    let imageURL: String
    let state, ownerUid, category: String
    //let timestamp: Timestamp
    let paidUsers: [String]
    //let refundRequestedUsers: [JSONAny]
    let hr, storyPost, task: Int

    enum CodingKeys: String, CodingKey {
        case country, city, jobBio
        case imageURL = "imageUrl"
        case state, ownerUid, category, paidUsers, hr, storyPost, task
    }
}


