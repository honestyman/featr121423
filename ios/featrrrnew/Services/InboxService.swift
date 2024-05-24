//
//  InboxService.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/10/23.
//

import Foundation
import Firebase

class InboxService {
    
    public static let shared = InboxService()
    
    @Published var documentChanges = [DocumentChange]()
        
    private var firestoreListener: ListenerRegistration?
    
    func observeRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages")
            .order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { snapshot, _ in
            guard let changes = snapshot?.documentChanges.filter({$0.type == .added || $0.type == .modified}) else {return}
            self.documentChanges = changes
        }
    }
    
    func reset() {
        self.firestoreListener?.remove()
        self.firestoreListener = nil
        self.documentChanges.removeAll()
    }
}
