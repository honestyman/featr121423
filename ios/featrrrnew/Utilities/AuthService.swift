//
//  AuthService.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import Foundation
import Firebase


class AuthService {
    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?
    @Published var errorMessage = ""
    
    static let shared = AuthService()
    
    init() {
        Task { try await loadUserData() }
        loadCurrentUserData()
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            self.user = try await UserService.fetchUser(withUid: result.user.uid)
            loadCurrentUserData()
        } catch {
            Log.d("Login failed \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            
            let data: [String: Any] = [
                "email": email,
                "username": username,
                "id": result.user.uid
            ]
            
            try await COLLECTION_USERS.document(result.user.uid).setData(data)
            self.user = try await UserService.fetchUser(withUid: result.user.uid)
            loadCurrentUserData()
        } catch {
            Log.d("Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadUserData() async throws {
        userSession = Auth.auth().currentUser
        
        if let session = userSession {
            self.user = try await UserService.fetchUser(withUid: session.uid)
        }
    }
    
    func signout() {
        self.userSession = nil
        self.user = nil
        try? Auth.auth().signOut()
        InboxService.shared.reset()
    }
    
    private func loadCurrentUserData() {
        Task { try await UserService.shared.fetchCurrentUser() }
    }
}

