//
//  SearchViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/24/23.
//

import SwiftUI
import Firebase

enum SearchViewModelConfig: Hashable {
   
    case search
    case newMessage
    
    var navigationTitle: String {
        switch self {
       
        case .search:
            return "Explore"
        case .newMessage:
            return "NewMessage"
        }
    }
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var users = [User]()
    private let config: SearchViewModelConfig
    private var lastDoc: QueryDocumentSnapshot?
    
    init(config: SearchViewModelConfig) {
        self.config = config
        fetchUsers(forConfig: config)
    }
    
    func fetchUsers() async {
        guard (Auth.auth().currentUser?.uid) != nil else { return }
        let query = COLLECTION_USERS.limit(to: 20)
                
        if let last = lastDoc {
            let next = query.start(afterDocument: last)
            guard let snapshot = try? await next.getDocuments() else { return }
            self.lastDoc = snapshot.documents.last
            self.users.append(contentsOf: snapshot.documents.compactMap({ try? $0.data(as: User.self) }))
        } else {
            guard let snapshot = try? await query.getDocuments() else { return }
            self.lastDoc = snapshot.documents.last
            self.users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })//.filter({ $0.id != currentUid })
        }
    }
    
    func fetchUsers(forConfig config: SearchViewModelConfig) {
        Task {
            switch config {
           
            case .search, .newMessage:
                Log.d("Fetching users")
                await fetchUsers()
            }
        }
    }
    
    private func fetchUsers(_ snapshot: QuerySnapshot?) async throws {
        guard let documents = snapshot?.documents else { return }
        
        for doc in documents {
            let user = try await UserService.fetchUser(withUid: doc.documentID)
            users.append(user)
        }
    }
    
    func filteredUsers(_ query: String) -> [User] {
        let lowercasedQuery = query.lowercased()
        return users.filter({
            $0.fullname?.lowercased().contains(lowercasedQuery) ?? false ||
            $0.username.contains(lowercasedQuery)
        })
    }
}
