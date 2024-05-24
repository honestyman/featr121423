//
//  PendingListItemView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/20/24.
//

import SwiftUI
import Kingfisher
import StripePaymentSheet

class PendingListItemViewModel: ObservableObject {
    
    let jobProposal: JobProposal
    
    @Published private(set) var job: JobPost?
    @ObservedObject var paymentViewModel: PaymentViewModel
    
    init(jobProposal: JobProposal, paymentViewModel: PaymentViewModel) {
        self.jobProposal = jobProposal
        self.paymentViewModel = paymentViewModel
        Task { [weak self] in
            do {
                let fetchedJob = try await JobService.standard.fetchJob(withId: jobProposal.jobID)
                DispatchQueue.main.async { [weak self] in
                    self?.job = fetchedJob
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    //TODO: Handle the error
                    self?.job = nil
                }
            }
        }
    }
    
    init(jobProposal: JobProposal, job: JobPost, paymentViewModel: PaymentViewModel) {
        self.jobProposal = jobProposal
        self.job = job
        self.paymentViewModel = paymentViewModel
    }
    
    @Published var paymentSheet: PaymentSheet? = nil
    @Published var preparingPaymentSheet = false
    @Published var showPaymentError = false
    @Published var paymentError: String? = nil
    
     func preparePaymentSheet() {
        preparingPaymentSheet = true
        if let job {
            Task {
                guard let user = try? await UserService.fetchUser(withUid: jobProposal.sellerID) else {
                    //TODO: Display an error while trying to fetch user
                    paymentError = "Can't access the current seller user's object"
                    showPaymentError = true
                    Log.d("Can't access the current seller user \(jobProposal.sellerID)")
                    return
                }
                PaymentService.standard.preparePaymentSheet(payment: calculateCost(), job: job, toUser: user) { [weak self] pS in
                    
                        do {
                            let result = try pS.get()
                            DispatchQueue.main.async { [weak self] in
                                self?.paymentSheet = result
                                self?.preparingPaymentSheet = false
                            }
                        } catch {
                            Log.d("Can't prepare payment sheet: \( error.localizedDescription)")
                            DispatchQueue.main.async { [weak self] in
                                self?.paymentError = error.localizedDescription
                                self?.showPaymentError = true
                            }
                        }
                    
                }
            }
        } //TODO: Error handling
    }
    
    func completedPayment(result: PaymentSheetResult) {
        switch result {
        case .canceled:
            paymentSheet = nil
            preparingPaymentSheet = false
           
        case .completed:
            paymentSheet = nil
            preparingPaymentSheet = false
            JobProposalService.standard.complete(proposalId: jobProposal.id, completionCost: calculateCost()) { [weak self] result in
                
                self?.paymentViewModel.popoverStatus = .completed
                self?.paymentViewModel.displayPopoverOpacity = 1.0
                
                    Task { [weak self] in
                        await self?.paymentViewModel.fetchPendingRequests()
                    }
                
               
            }
        case .failed(let error):
            paymentError = error.localizedDescription
            showPaymentError = true
           
        }
    }
    
    public func calculateCost() -> Double {
        var total: Double = 0.0
        let proposal = jobProposal.proposal
            if proposal.hourly ?? false {
                if let hourlyDuration = proposal.hourlyDuration, let hourlyRate = proposal.hourlyRate {
                    total += hourlyDuration*Double(hourlyRate)
                }
            }
            if proposal.task ?? false {
                if let taskCost = proposal.taskRate {
                    total += Double(taskCost)
                }
            }
            if proposal.story ?? false {
                if let storyCost = proposal.storyRate {
                    total += Double(storyCost)
                }
            }
        
        return total
    }
    func cancelPending() {
        JobProposalService.standard.cancel(proposalId: jobProposal.id) { [weak self] result in
            self?.paymentViewModel.popoverStatus = .cancelled
            self?.paymentViewModel.displayPopoverOpacity = 1.0
            
           
                Task { [weak self] in
                    await self?.paymentViewModel.fetchPendingRequests()
                   
                }
            
            
            
        }
    }
    
}

struct PendingListItemView: View{
    
    @ObservedObject var viewModel: PendingListItemViewModel
    let horizontalPadding: CGFloat = 20
    
    @ViewBuilder
    var cardTitle: some View {
        
        if let job = viewModel.job {
            Text("\(job.category)")
                .textCase(.uppercase)
                .font(Style.font.title3)
                .foregroundColor(Color.foreground)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    var cardImage: some View {
        
        if let job = viewModel.job {
            
            ZStack(alignment: .topTrailing) {
                
                
                
                ImageCarousel(urls: job.imageUrls, padding: .init(top: 0, leading: horizontalPadding, bottom: 0, trailing: horizontalPadding))
                    .refundSized()
                    .pageControllerOffset(x: 12)
                
                
                Text("\u{2192}") //Side arrow (􀰑)
                    .font(Style.font.title2)
                    .padding(.sm)
                    .foregroundColor(Color.background)
                
            }
        }
        
    }
    
    @ViewBuilder
    var cardPriceOverlay: some View {
        
        if let job = viewModel.job {
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        if viewModel.jobProposal.proposal.task ?? false {
                            Text(String.formatCurrency(Double(job.task)))
                                .font(Style.font.caption)
                            Text("task")
                                .font(Style.font.caption2)
                        } else {
                            Image(systemName: "xmark").opacity(0.4)
                        }
                    }
                    Spacer()
                    Divider().frame(width: 1).overlay(Color.background)
                    Spacer()
                    VStack {
                        if let hourly = viewModel.jobProposal.proposal.hourly, let hourlyRate = viewModel.jobProposal.proposal.hourlyRate, let duration = viewModel.jobProposal.proposal.hourlyDuration, hourly == true {
                            Text(String.formatCurrency(hourlyRate))
                                .font(Style.font.caption)
                            Text("@\(String.formatTime(duration))hrs")
                                .font(Style.font.caption2)
                            Text("hour")
                                .font(Style.font.caption2)
                        } else {
                            Image(systemName: "xmark").opacity(0.4)
                        }
                    }
                    Spacer()
                    Divider().frame(width: 1).overlay(Color.background)
                    Spacer()
                    VStack {
                        if viewModel.jobProposal.proposal.story ?? false {
                            Text(String.formatCurrency(Double(job.storyPost)))
                                .font(Style.font.caption)
                            Text("story")
                                .font(Style.font.caption2)
                        } else {
                            Image(systemName: "xmark").opacity(0.4)
                        }
                    }
                    Spacer()
                }
                Divider().overlay(Color.background)
                Text("\(String.formatCurrency(viewModel.calculateCost())) TOTAL")
                    .font(Style.font.caption)
                    .padding(.bottom, .xxsm)
            }
            .foregroundColor(Color.background)
            .background(RoundedRectangle(cornerRadius: .cornerS).fill(Color.primary))
            .frame(maxWidth: .infinity)
        }
    }
    
    var body: some View{
        ZStack {
            if let job = viewModel.job {
                VStack(spacing: CGFloat.md) {
                    HStack(spacing: CGFloat.md) {
                        cardImage
                        VStack {
                            cardTitle
                            cardPriceOverlay
                        }.frame(height: 160)
                    }
                    HStack {
                        Button(action: {
                            viewModel.cancelPending()
                        }, label: {
                            Text("Cancel")
                                .frame(maxWidth: .infinity)
                                .font(Style.font.caption)
                                .padding(.sm)
                                .background(
                                    RoundedRectangle(cornerRadius: .cornerL).fill(Color.lightBackground))
                                .foregroundColor(Color.background)
                        })
                        if let paymentSheet = viewModel.paymentSheet {
                            PaymentSheet.PaymentButton(
                                paymentSheet: paymentSheet,
                                onCompletion: viewModel.completedPayment
                            ) {
                                HStack {
                                    Image(systemName: "creditcard.fill")
                                        .tint(Color.background)
                                    Text("\(String.formatCurrency(viewModel.calculateCost()))")
                                        .font(Style.font.caption)
                                        .padding(.sm)
                                        
                                }
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: .cornerL).fill(Color.success))
                                .foregroundColor(Color.background)
                                    
                                
                            }
                        } else {
                            Button(action: {
                                viewModel.preparePaymentSheet()
                            }, label: {
                                if !viewModel.preparingPaymentSheet {
                                    HStack {
                                        Text("Checkout")
                                    }
                                } else {
                                    ProgressView().tint(Color.background)
                                }
                            }).frame(maxWidth: .infinity)
                                .font(Style.font.caption)
                                .padding(.sm)
                                .background(
                                    RoundedRectangle(cornerRadius: .cornerL).fill(Color.primary))
                                .foregroundColor(Color.background)
                        }
                    }
                    
                }.alert(viewModel.paymentError ?? "", isPresented: $viewModel.showPaymentError) {
                    Button("OK") {
                        viewModel.preparingPaymentSheet = false
                    }
                }
            } else {
                ProgressView()
            }
            
        }
            
    }
    
}

struct PendingListItemView_Previews: PreviewProvider {
    static var previews: some View {
        PendingListItemView(viewModel: PendingListItemViewModel(jobProposal: dev.jobProposal[0], job: dev.jobs[2], paymentViewModel: PaymentViewModel()))
    }
}



