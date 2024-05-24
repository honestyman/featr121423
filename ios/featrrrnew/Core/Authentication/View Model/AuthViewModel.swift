//
//  AuthViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink = false
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    
    static let shared = AuthViewModel()
        
    init() {
        userSession = Auth.auth().currentUser
    }
    
    func signout() {
        self.userSession = nil
        self.currentUser = nil
        try? Auth.auth().signOut()
    }
    
    @MainActor
    func resetPassword(withEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                Log.d("Failed to send link with error \(error.localizedDescription)")
                return
            }
            
            self.didSendResetPasswordLink = true
        }
    }
}
