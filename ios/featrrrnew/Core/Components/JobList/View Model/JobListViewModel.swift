//
//  JobListViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import SwiftUI
import Firebase

class JobListViewModel: ObservableObject {
    @Published var jobs = [JobPost]()
    @Published public private(set) var user: User
    private var lastDoc: QueryDocumentSnapshot?
    
    init(user: User) {
        self.user = user
        reload()
    }
    
    func reload() {
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
