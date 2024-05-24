//
//  RootViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/23/23.
//

import Foundation
import Firebase
import Combine


class RootViewModel: ObservableObject {
    
    private let service = AuthService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        configureSubscribers()
    }
    
    func configureSubscribers() {
        service.$user
            .sink { [weak self] user in
                self?.currentUser = user
            }.store(in: &cancellables)
        
        service.$userSession
            .sink { [weak self] session in
                self?.userSession = session
            }.store(in: &cancellables)
    }
}
