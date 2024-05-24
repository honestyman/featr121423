//
//  LoginViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/23/23.
//

import Foundation
import FirebaseAuth



class LoginViewModel: ObservableObject {
    //@Published var errorMessage = ""
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var authError: AuthError?
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
        } catch {
            let authError = AuthErrorCode.Code(rawValue: (error as NSError).code)
            self.showAlert = true
            self.authError = AuthError(authErrorCode: authError ?? .userNotFound)
        }
    }
    
   /*func signInAnonymous() async throws {
      await AuthService.shared.signInAnonymous()
    }*/
    
}
