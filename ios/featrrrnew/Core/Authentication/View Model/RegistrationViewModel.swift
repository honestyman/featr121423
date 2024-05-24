//
//  RegistrationViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/23/23.
//




import Foundation
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var emailIsValid = false
    @Published var usernameIsValid = false
    @Published var isLoading = false
    @Published var emailValidationFailed = false
    @Published var usernameValidationFailed = false
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    func createUser() async throws {
        //try await AuthService.shared.createUser(email: email, password: password, username: username)
        do {
            try await AuthService.shared.createUser(email: email, password: password, username: username)
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
    
    
    @MainActor
    func validateEmail() async throws {
        self.isLoading = true
        self.emailValidationFailed = false
        let snapshot = try await COLLECTION_USERS.whereField("email", isEqualTo: email).getDocuments()
        self.emailValidationFailed = !snapshot.isEmpty
        self.emailIsValid = snapshot.isEmpty
        self.isLoading = false
    }
    
    @MainActor
    func validateUsername() async throws {
        self.isLoading = true
        let snapshot = try await COLLECTION_USERS.whereField("username", isEqualTo: username).getDocuments()
        self.usernameIsValid = snapshot.isEmpty
        self.isLoading = false
    }
    
}
