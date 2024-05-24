//
//  FeedViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import SwiftUI
import Firebase

@MainActor
class FeedViewModel: ObservableObject {
    
    /// Manually published variable
    var jobs = [JobPost]()
    var userProposals: [JobProposal]?
    
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var category: String = ""
    
    init() {
        reload()
    }
    
    public func reload() {
        Task {
            try await fetchJobsWithUserData()
            try await fetchCurrentUserJobBids()
        }
    }
    
    public func updateFilter(category: String, city: String, state: String, country: String) {
        self.category = category
        self.city = city
        self.state = state
        self.country = country
        
        Task {
            try await fetchJobsWithUserData()
        }
    }
        
    internal func fetchJobIDs() async -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try? await COLLECTION_USERS.document(uid).collection("user-feed").getDocuments()
        return snapshot?.documents.map({ $0.documentID }) ?? []
    }
    
    internal func fetchJobs() async throws {
        let jobIDs = await fetchJobIDs()
                
        try await withThrowingTaskGroup(of: JobPost.self, body: { group in
            var jobs = [JobPost]()
            
            for id in jobIDs {
                group.addTask { return try await JobService.standard.fetchJob(withId: id) }
            }
            
            for try await job in group {
                jobs.append(try await fetchJobUserData(job: job))
            }
            
            self.jobs = jobs.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            objectWillChange.send()
        })
    }
    
    internal func fetchJobUserData(job: JobPost) async throws -> JobPost {
        var result = job
    
        async let jobUser = try await UserService.fetchUser(withUid: job.ownerUid)
        result.user = try await jobUser

        return result
    }
}

// fetch all jobs
extension FeedViewModel {
    internal func fetchAllJobs() async throws {
        // TODO: - We need to add index to firebase for each query.
        var query: Query = COLLECTION_JOBS.order(by: "timestamp", descending: true)
        if(!category.isEmpty) {
            query = query.whereField("category", isEqualTo: category)
        }
        if(!city.isEmpty) {
            query = query.whereField("city", isEqualTo: city)
        }
        if(!state.isEmpty) {
            query = query.whereField("state", isEqualTo: state)
        }
        if(!country.isEmpty) {
            query = query.whereField("country", isEqualTo: country)
        }
        
        let snapshot = try? await query.getDocuments()
        
        guard let documents = snapshot?.documents else { return }
        
        self.jobs = documents.compactMap({
            do {
                return try $0.data(as: JobPost.self)
            }catch {
                Log.d(error.localizedDescription)
                return nil
            }
        })
        
    }
    
    internal func fetchCurrentUserJobBids() async throws {
        if let currentUser = AuthService.shared.user?.id {
            JobProposalService.standard.getProposals(forUserID: currentUser) { [weak self] proposalsResults in
                do {
                    var proposals = try proposalsResults.get()
                    self?.userProposals = proposals
                    
                } catch {
                   //TODO: Currently silently fails - may need to throw an error
                    self?.userProposals = nil
                    Log.d("There was an error when fetching the current user's job bids \(error.localizedDescription)")
                }
                self?.objectWillChange.send()
            }
        }
    }
    internal func fetchJobsWithUserData() async throws {
        try await fetchAllJobs()
        
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for job in jobs {
                group.addTask { try await self.fetchUserData(forJob: job) }
            }
        })
        
        objectWillChange.send()
    }
    
    internal func fetchUserData(forJob job: JobPost) async throws {
        guard let indexOfJob = jobs.firstIndex(where: { $0.id == job.id }) else { return }
        
        async let user = try await UserService.fetchUser(withUid: job.ownerUid)
        self.jobs[indexOfJob].user = try await user
        
    }
}
