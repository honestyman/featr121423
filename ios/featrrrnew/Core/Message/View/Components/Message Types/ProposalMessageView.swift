//
//  ProposalMessageView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/19/24.
//

import SwiftUI

class ProposalMessageViewModel: ObservableObject {
    @Published var jobProposal: JobProposal?
    @Published var job: JobPost?
    @Published var buyerUser: User?
    @Published var sellerUser: User?
    
    let currentUser: Bool
    
    init(currentUser: Bool, jobProposal: JobProposal, job: JobPost, sellerUser: User, buyerUser: User) {
        self.jobProposal = jobProposal
        self.job = job
        self.sellerUser = sellerUser
        self.buyerUser = buyerUser
        self.currentUser = currentUser
    }
    init(currentUser: Bool, id jobProposalID: String) {
        
        self.currentUser = currentUser
        
        JobProposalService.standard.getProposal(from: jobProposalID, completion: { [weak self] result  in
            do {
                let jobProposal = try result.get()
                
                
                    Task { [weak self] in
                        do {
                            let job = try await JobService.standard.fetchJob(withId: jobProposal.jobID)
                            let user: User
                            
                            let seller = try await UserService.fetchUser(withUid: jobProposal.sellerID)
                            
                            let buyer = try await UserService.fetchUser(withUid: jobProposal.buyerID)
                            
                            DispatchQueue.main.async { [weak self] in
                                self?.job = job
                                self?.jobProposal = jobProposal
                                self?.buyerUser = buyer
                                self?.sellerUser = seller
                            }
                            
                        } catch {
                            
                            Log.d("There was an issue while fetching the  job or buyer user from the proposal")
                        }
                    }
                    
                
                
            } catch {
                Log.d("There was an issue while fetching the proposal")
            }
        })
    }
    public func calculateCost() -> Double {
        var total: Double = 0.0
        if let bid = jobProposal?.proposal {
            if bid.hourly ?? false {
                if let hourlyDuration = bid.hourlyDuration, let hourlyRate = bid.hourlyRate {
                    total += hourlyDuration*Double(hourlyRate)
                }
            }
            if bid.task ?? false {
                if let taskCost = bid.taskRate {
                    total += Double(taskCost)
                }
            }
            if bid.story ?? false {
                if let storyCost = bid.storyRate {
                    total += Double(storyCost)
                }
            }
        }
        return total
    }
}

extension ProposalMessageView {
    func notCurrentUserColoring() -> Self {
        var view = self
        view.backgroundColor = Color.lightBackground
        view.backgroundSecondaryColor = Color.lightBackground.opacity(0.4)
        view.foregroundColor = Color.background
        return view
    }
}

struct ProposalMessageView: View {
    @StateObject var viewModel: ProposalMessageViewModel
    var backgroundColor: Color = .primary
    var backgroundSecondaryColor: Color = .primary.opacity(0.4)
    var foregroundColor: Color = .background
    
    @ViewBuilder
    private var hourlyText: some View {
        if let proposal = viewModel.jobProposal?.proposal, let job = viewModel.job, let hourlyDuration = proposal.hourlyDuration, let hourlyStartDate = proposal.hourlyStartDate {
    
            if proposal.hourly ?? false {
                
                HStack {
                    Text("\(String.formatCurrency(Double(job.hr)*hourlyDuration))")
                        .padding(.sm)
                        .background(RoundedRectangle(cornerRadius: .cornerXL).fill(backgroundColor))
                    
                    (Text("hourly").bold() +
                     Text(" on \(String.formatDate(hourlyStartDate))"))
                    
                    Spacer()
                }
                
            }
        }
    }
    
    @ViewBuilder
    private var taskText: some View {
        if let proposal = viewModel.jobProposal?.proposal, let job = viewModel.job, let taskDate = proposal.taskDate {
            
            if proposal.task ?? false {
                HStack {
                    Text("\(String.formatCurrency(Double(job.task)))")
                        .padding(.sm)
                        .background(RoundedRectangle(cornerRadius: .cornerXL).fill(backgroundColor))
                    
                    (Text("task").bold() +
                     Text(" on \(String.formatDate(taskDate))"))
                    
                    Spacer()
                }
            }
        }
        
    }
    
    @ViewBuilder
    private var storyText: some View {
        if let jobProposal = viewModel.jobProposal, let job = viewModel.job, let storyDate = jobProposal.proposal.storyDate {
            
            if jobProposal.proposal.story ?? false {
                    HStack {
                        Text("\(String.formatCurrency(Double(job.storyPost)))")
                            .padding(.sm)
                            .background(RoundedRectangle(cornerRadius: .cornerXL).fill(backgroundColor))
                        
                        
                        (Text("story job").bold() + 
                         Text(" on \(String.formatDate(storyDate))"))
                        
                        Spacer()
                        
                       
                    }
                }
            
        }
    }
    
    
    @ViewBuilder
    private var totalText: some View {
        if let jobProposal = viewModel.jobProposal {
            HStack {
                Text("\(String.formatCurrency(viewModel.calculateCost()))")
                    .padding(.sm)
                    .background(RoundedRectangle(cornerRadius: .cornerXL).fill(backgroundColor))
                
                Text("total").bold()
                Spacer()
                
                if jobProposal.status == .completed {
                    Text("Paid")
                        .padding(.sm)
                        .background(RoundedRectangle(cornerRadius: .cornerXL).fill(Color.success))
                } else if jobProposal.status == .cancelled {
                    Text("Cancelled")
                        .padding(.sm)
                        .background(RoundedRectangle(cornerRadius: .cornerXL).fill(Color.warning))
                } else if jobProposal.status == .pending {
                    Text("Pending")
                        .padding(.sm)
                        .background(RoundedRectangle(cornerRadius: .cornerXL).fill(Color.lightBackground))
                        .foregroundColor(Color.background)
                }
            }
        }
    }

    
    @ViewBuilder
    private var headerText: some View {
        if let job = viewModel.job, let buyerUser = viewModel.buyerUser, let sellerUser = viewModel.sellerUser {
            if viewModel.currentUser {
                (Text("You would like to Featrrr ") +
                 Text("@\(sellerUser.username)").bold() +
                 Text(" for ") +
                 Text("\(job.category.uppercased())").underline())
                .font(Style.font.messageCaption)
                .padding(.vertical, .md)
                .padding(.horizontal, .sm)
            } else {
                (Text("@\(buyerUser.username)").bold() +
                 Text(" wants to Featrrr you for ") +
                 Text("\(job.category.uppercased())").underline())
                .font(Style.font.messageCaption)
                .padding(.vertical, .md)
                .padding(.horizontal, .sm)
            }
        }
    }
    var body: some View {
        VStack {
            if let proposal = viewModel.jobProposal?.proposal {
                
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading) { // HEADER
                        headerText
                    }
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    
                    VStack(spacing: CGFloat.sm) { // BODY
                        
                        VStack {
                            hourlyText
                                .font(Style.font.messageCaption)
                            taskText
                                .font(Style.font.messageCaption)
                            storyText
                                .font(Style.font.messageCaption)
                        }
                        
                        Divider().overlay(foregroundColor)
                        
                        VStack {
                            totalText
                                .font(Style.font.messageCaption)
                        }
                        
                    }
                    .padding(.sm)
                    .background(backgroundSecondaryColor)
                    
                }
                .foregroundColor(foregroundColor)
                .clipShape(ChatBubble(isFromCurrentUser: viewModel.currentUser))
                .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                
            } else {
                VStack(spacing: 0) {
                    
                    Text("Pending Job Proposal")
                        .font(Style.font.messageCaption)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, .sm)
                        .foregroundColor(foregroundColor)
                        .background(backgroundColor)
                    
                    HStack {
                        Spacer()
                        ProgressView().tint(foregroundColor)
                        Spacer()
                    }
                    .padding(.vertical, .sm)
                    .background(backgroundSecondaryColor)
                    
                } 
                .frame(maxWidth: UIScreen.main.bounds.width / 1.5, alignment: .trailing)
                .clipShape(ChatBubble(isFromCurrentUser: viewModel.currentUser))
                
            }
        }
        
        
    }
}

struct ProposalMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ProposalMessageView(viewModel: ProposalMessageViewModel(currentUser: false, jobProposal: dev.jobProposal[0], job: dev.jobs[3], sellerUser: dev.users[1], buyerUser: dev.users[0])).notCurrentUserColoring()
    }
}
