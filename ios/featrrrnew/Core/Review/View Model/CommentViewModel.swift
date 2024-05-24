//
//  CommentViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI
import Firebase

@MainActor
class CommentViewModel: ObservableObject {
    private let job: JobPost
    private let jobId: String
    @Published var reviews = [Review]()
    
    init(job: JobPost) {
        self.job = job
        self.jobId = job.id ?? ""
        
        Task { try await fetchReviews() }
    }
    
    func uploadReview(reviewText: String) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let currentUser = AuthViewModel.shared.currentUser else { return }
        
        let data: [String: Any] = ["reviewOwnerUid": uid,
                                   "timestamp": Timestamp(date: Date()),
                                   "jobOwnerUid": job.ownerUid,
                                   "jobId": jobId,
                                   "reviewText": reviewText]
        
        let _ = try? await COLLECTION_JOBS.document(jobId).collection("job-reviews").addDocument(data: data)
        NotificationsViewModel.uploadNotification(toUid: self.job.ownerUid, type: .review, job: self.job)
        self.reviews.insert(Review(user: currentUser, data: data), at: 0)
    }
    
    func fetchReviews() async throws {
        let query = COLLECTION_JOBS.document(jobId).collection("job-reviews").order(by: "timestamp", descending: true)
        guard let reviewSnapshot = try? await query.getDocuments() else { return }
        let documentData = reviewSnapshot.documents.compactMap({ $0.data() })
        
        for data in documentData {
            guard let uid = data ["reviewOwnerUid"] as? String else { return }
            let user = try await UserService.fetchUser(withUid: uid)
            let reviews = Review(user: user, data: data)
            self.reviews.append(reviews)
        }
    }
}

// MARK: - Deletion

/*extension CommentViewModel {
    func deleteAllReviews() {
        COLLECTION_JOBS.getDocuments { snapshot, _ in
            guard let jobIDs = snapshot?.documents.compactMap({ $0.documentID }) else { return }
            
            for id in jobIDs {
                COLLECTION_JOBS.document(id).collection("job-reviews").getDocuments { snapshot, _ in
                    guard let reviewIDs = snapshot?.documents.compactMap({ $0.documentID }) else { return }
                    
                    for reviewId in reviewIDs {
                        COLLECTION_JOBS.document(id).collection("job-review").document(reviewId).delete()
                    }
                }
            }
        }
    }
}*/
