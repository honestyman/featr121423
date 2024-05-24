//
//  ProfileViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI
import Firebase

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
        
    }
}


@MainActor
class FeedProfileViewModel: ProfileViewModel {
    @Published var jobs = [JobPost]()
    private var lastDoc: QueryDocumentSnapshot?
    //private let user: User
    
    override init(user: User) {
        super.init(user: user)
        
        Task { try await fetchUserJobs(forUser: user)}
    }
    
    func fetchJobs() {
        
            Task { try await fetchUserJobs(forUser: user) }
        }
    
    
    func fetchExplorePageJobs() {
        let query = COLLECTION_JOBS.limit(to: 20).order(by: "timestamp", descending: true)
        
        if let last = lastDoc {
            let next = query.start(afterDocument: last)
            next.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents, !documents.isEmpty else { return }
                self.lastDoc = snapshot?.documents.last
                self.jobs.append(contentsOf: documents.compactMap({ try? $0.data(as: JobPost.self) }))
            }
        } else {
            query.getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                self.jobs = documents.compactMap({ try? $0.data(as: JobPost.self) })
                self.lastDoc = snapshot?.documents.last
            }
        }
    }
    
    @MainActor
    func fetchUserJobs(forUser user: User) async throws {
        let jobs = try await JobService.standard.fetchUserJobs(user: user)
       
        self.jobs = jobs
    }
}
