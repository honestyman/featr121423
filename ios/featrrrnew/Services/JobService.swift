//
//  JobService.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import Foundation
import Firebase

struct JobService {
    
    public static let standard = JobService()
    
    func fetchJob(withId id: String) async throws -> JobPost {
        let jobSnapshot = try await COLLECTION_JOBS.document(id).getDocument()
        let job = try jobSnapshot.data(as: JobPost.self)
        return job
    }
    
    func fetchUserJobs(user: User) async throws -> [JobPost] {
        let snapshot = try await COLLECTION_JOBS.whereField("ownerUid", isEqualTo: user.id).getDocuments()
       
        var jobs = snapshot.documents.compactMap({try? $0.data(as: JobPost.self )})
        
        for i in 0 ..< jobs.count {
            jobs[i].user = user
        }
        
        return jobs
    }
}
