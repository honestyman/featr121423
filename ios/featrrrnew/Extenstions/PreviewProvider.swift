//
//  PreviewProvider.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    var user = User(
        uid: NSUUID().uuidString,
        username: "TestUser",
        email: "vv@gmail.com",
        profileImageUrls: ["https://via.placeholder.com/300.png"],
        fullname: "Sakura Chan"
    )
    
    var jobProposal: [JobProposal] = [
        .init(sellerID: "abcdefg", buyerID: "abcdefg", jobID: "abcdefg", status: .pending, proposal: Proposal(hourly: true, hourlyStartDate: Date.now, hourlyDuration: 12.2, hourlyRate: 0.0, task: true, taskDate: Date.now, taskRate: 0.0, story: true, storyDate: Date.now, storyRate: 0.0))
    ]
    
    var users: [User] = [
        .init(
            uid: NSUUID().uuidString,
            username: "malemodel",
            email: "mm@gmail.com",
            profileImageUrls: ["malemodel"],
            fullname: "Ty Lue"
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "videographer",
            email: "vo@gmail.com",
            profileImageUrls: ["videographer"],
            fullname: "Bruce Wayne"
        ),

        .init(
            uid: NSUUID().uuidString,
            username: "photgrapher",
            email: "po@gmail.com",
            profileImageUrls: ["photgrapher"],
            fullname: "First Bawn"
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "model",
            email: "mo@gmail.com",
            profileImageUrls: ["model"],
            fullname: "Love Spawn"
        ),
    ]
    
    var jobs: [JobPost] = [

        .init(
            id: NSUUID().uuidString,
             ownerUid: "malemodel",
             jobBio: "Love collabing w future legends",
             rating: 0,
             imageUrls: ["malemodel"],
             timestamp: Timestamp(date: Date()),
            hr: 100,
             task: 60,
             storyPost: 30,
             city: "Manhattan",
             state: "New York",
             country: "US",
            category: "male model",
            paidUsers: [],
            refundRequestedUsers: [],
            user: User(
                uid: NSUUID().uuidString,
                username: "malemodel",
                email: "mm@gmail.com",
                profileImageUrls: ["malemodel"],
                fullname: "Ty Lue"
            )
        ),
        .init(
            id: NSUUID().uuidString,
             ownerUid: "videographer",
             jobBio: "Love collabing w future legends",
             rating: 0,
             imageUrls: ["videographer"],
             timestamp: Timestamp(date: Date()),
                hr: 200,
             task: 150,
             storyPost: 40,
             city: "Detroit",
             state: "Michigan",
             country: "US",
            category: "videographer",
            paidUsers: [],
            refundRequestedUsers: [],
            user: User(
                uid: NSUUID().uuidString,
                username: "videographer",
                email: "vo@gmail.com",
                profileImageUrls: ["videographer"],
                fullname: "Bruce Wayne"
            )
        ),
        .init(
            id: NSUUID().uuidString,
             ownerUid: "photgrapher",
             jobBio: "Love collabing w future legends",
             rating: 0,
             imageUrls: ["https://via.placeholder.com/700.png"],
             timestamp: Timestamp(date: Date()),
            hr: 150,
             task: 80,
             storyPost: 35,
             city: "Los Angeles",
             state: "California",
             country: "US",
            category: "photgrapher",
            paidUsers: [],
            refundRequestedUsers: [],
            user: User(
                uid: NSUUID().uuidString,
                username: "photgrapher",
                email: "po@gmail.com",
                profileImageUrls: ["https://via.placeholder.com/200.png"],
                fullname: "First Bawn"
            )
        ),
        .init(
            id: NSUUID().uuidString,
             ownerUid: "model",
             jobBio: "Love collabing w future legends",
             rating: 0,
             imageUrls: ["model"],
             timestamp: Timestamp(date: Date()),
            hr: 140,
             task: 90,
             storyPost: 60,
             city: "Miami",
             state: "Florida",
             country: "US",
            category: "CREATE A VIDEO OF A CAT DOING A BACKFLIP FOR ME",
            paidUsers: [],
            refundRequestedUsers: [],
            user: User(
                uid: NSUUID().uuidString,
                username: "model",
                email: "mo@gmail.com",
                profileImageUrls: ["model"],
                fullname: "Love Spawn"
            )
        ),
    ]
}
