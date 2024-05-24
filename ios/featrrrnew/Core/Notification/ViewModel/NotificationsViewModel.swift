//
//  NotificationsViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI
import Firebase

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications = [Notification]()
    
    init() {
        Task { try await updateNotifications() }
    }
    
    private func fetchNotifications() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let query = COLLECTION_NOTIFICATIONS
            .document(uid).collection("user-notifications")
            .order(by: "timestamp", descending: true)

        guard let snapshot = try? await query.getDocuments() else { return }
        self.notifications = snapshot.documents.compactMap({ try? $0.data(as: Notification.self) })
    }
    
    func updateNotifications() async throws {
        await fetchNotifications()
        
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for notification in notifications {
                group.addTask { try await self.updateNotificationMetadata(notification: notification) }
            }
        })
    }
    
    static func deleteNotification(toUid uid: String, type: NotificationType, jobId: String? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications")
            .whereField("uid", isEqualTo: currentUid).getDocuments { snapshot, _ in
                snapshot?.documents.forEach({ document in
                    let notification = try? document.data(as: Notification.self)
                    guard notification?.type == type else { return }
                    
                    if jobId != nil {
                        guard jobId == notification?.jobId else { return }
                    }
                    
                    document.reference.delete()
                })
            }
    }
    
    static func uploadNotification(toUid uid: String, type: NotificationType, job: JobPost? = nil) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentUid else { return }
        
        var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
                                   "uid": currentUid,
                                   "type": type.rawValue]
        
        if let job = job, let id = job.id {
            data["jobId"] = id
        }
        
        COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").addDocument(data: data)
    }
    
    private func updateNotificationMetadata(notification: Notification) async throws {
        guard let indexOfNotification = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        
        async let notificationUser = try await UserService.fetchUser(withUid: notification.uid)
        self.notifications[indexOfNotification].user = try await notificationUser


        if let jobId = notification.jobId {
            async let jobSnapshot = await COLLECTION_JOBS.document(jobId).getDocument()
            self.notifications[indexOfNotification].job = try? await jobSnapshot.data(as: JobPost.self)
        }
    }
}
