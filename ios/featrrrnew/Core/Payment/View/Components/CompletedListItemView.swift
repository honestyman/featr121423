//
//  PendingListItemView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/20/24.
//

import SwiftUI
import Kingfisher
import StripePaymentSheet

class CompletedListItemViewModel: ObservableObject {
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
    
    
}

struct CompletedListItemView: View{
    
    @ObservedObject var viewModel: CompletedListItemViewModel
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
                
            }
        }
        
    }
    
    @ViewBuilder
    var cardPriceOverlay: some View {
        
        if let job = viewModel.job, let completionCost = viewModel.jobProposal.completionCost {
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        if viewModel.jobProposal.proposal.task ?? false {
                            Text("$\(job.task)")
                                .font(Style.font.caption2)
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
                        if let hourly = viewModel.jobProposal.proposal.hourly, let duration = viewModel.jobProposal.proposal.hourlyDuration, hourly == true {
                            Text("$\(job.hr)")
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
                            Text("$\(job.storyPost)")
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
                Text("\(String.formatCurrency(completionCost)) TOTAL")
                    .font(Style.font.caption)
                    .padding(.bottom, .xxsm)
            }
            .foregroundColor(Color.background)
            .background(RoundedRectangle(cornerRadius: .cornerS).fill(Color.primary))
            .frame(maxWidth: .infinity)
        }
    }
    
    var body: some View{
        if viewModel.job != nil {
            VStack(spacing: CGFloat.md) {
                HStack(spacing: CGFloat.md) {
                    cardImage
                    VStack {
                        cardTitle
                        cardPriceOverlay
                    }.frame(height: 160)
                }
            }
        } else {
            ProgressView()
        }
    }
    
}

struct CompletedListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedListItemView(viewModel: CompletedListItemViewModel(jobProposal: dev.jobProposal[0], job: dev.jobs[2], paymentViewModel: PaymentViewModel()))
    }
}



