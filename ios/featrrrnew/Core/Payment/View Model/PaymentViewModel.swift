//
//  RefundViewModel.swift
//  SwiftUIProject
//
//  Created by CodistanVentures on 10/30/23.
//

import Foundation
import StripePaymentSheet

final class PaymentViewModel: ObservableObject{
   
    @Published public var selectedMode: CardSelectedMode = .pending
    
    @Published private(set) var isLoading: Bool = false
    
    @Published private(set) var selection: JobProposalStatus = .pending
    
    @Published private(set) var completedRequests: [JobProposal] = []
    @Published private(set) var pendingRequests: [JobProposal] = []

    @Published private(set) var errorMessage: String = ""
    @Published var showError: Bool = false
    
    @Published var displayPopoverOpacity: Double = 0.0
    @Published var popoverStatus: JobProposalStatus = .none
    
    init() {  
        Task {
            await self.fetchPendingRequests()
            DispatchQueue.main.async { [weak self] in
                self?.selectedMode = .pending
            }
        }
    }
    init(selectedProposalID: String) {
       
            JobProposalService.standard.getProposal(from: selectedProposalID) { [weak self] proposal in
                if let proposal = try? proposal.get() {
                    if proposal.status == .completed {
                        Task { [weak self] in
                            await self?.fetchCompletedRequests()
                            DispatchQueue.main.async { [weak self] in
                                self?.selectedMode = .completed
                            }
                        }
                    } else {
                        Task { [weak self] in
                            await self?.fetchPendingRequests()
                            DispatchQueue.main.async { [weak self] in
                                self?.selectedMode = .pending
                            }
                        }
                        
                    }
                   
                } //Can silently fail
            
        }
    }
    
    func fetchCompletedRequests() async {
        showLoadingView()
        DispatchQueue.main.async {
            self.selection = .completed
        }
        
        if let currentUser = AuthService.shared.user?.id {
            JobProposalService.standard.getProposals(forUserID: currentUser, selection: .completed) { result in
                do {
                    
                    let completedProposals = try result.get()
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.completedRequests = completedProposals
                    }
                } catch {
                    
                    //RACE CONDITION -> ADD TO TASK QUEUE
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                        self.completedRequests = []
                        self.showError = true
                    }
                }
            }
        } else {
            Log.d("There was no current user id available")
            DispatchQueue.main.async {
                self.errorMessage = "There was no current user id available"
                self.completedRequests = []
                self.showError = true
            }
        }
    }
    
    func fetchPendingRequests() async {
        showLoadingView()
        DispatchQueue.main.async {
            self.selection = .pending
        }
        
        if let currentUser = AuthService.shared.user?.id {
            JobProposalService.standard.getProposals(forUserID: currentUser, selection: .pending) { [weak self] result in
                do {
                    
                    let pendingProposals = try result.get()
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.isLoading = false
                        self?.pendingRequests = pendingProposals
                    }
                } catch {
                    
                    //RACE CONDITION -> ADD TO TASK QUEUE
                    DispatchQueue.main.async { [weak self] in
                        self?.errorMessage = error.localizedDescription
                        self?.pendingRequests = []
                        self?.showError = true
                    }
                }
            }
        } else {
            Log.d("There was no current user id available")
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "There was no current user id available"
                self?.pendingRequests = []
                self?.showError = true
            }
        }
    }
    
    private func showLoadingView(){
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
}
