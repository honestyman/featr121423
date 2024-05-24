//
//  FeedCell.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/27/23.
//


import SwiftUI
import Kingfisher

enum JobLinkValue: Hashable {
    case job(JobPost)
    case profile(JobPost)
    
}

struct JobRow: View {
    
    
    public var jobProposalStatus: JobProposalStatus
    @ObservedObject var viewModel: FeedRowViewModel
    public var linkVal: JobLinkValue?
    public var margin = 0
    
    @State private var bottomSheet = false
    @State private var selectedImageIndex = 0
    
    private var headerHidden = false
    private let horizontalPadding: CGFloat
    
    init(jobProposalStatus: JobProposalStatus, viewModel: FeedRowViewModel, margin: CGFloat = 28, linkVal: JobLinkValue? = nil) {
        self.jobProposalStatus = jobProposalStatus
        self.viewModel = viewModel
        self.linkVal = linkVal
        self.horizontalPadding = margin
    }
    
    @ViewBuilder
    var cardHeader: some View {
        
        if let user = viewModel.job.user {
            HStack(spacing: CGFloat.sm) {
                CircularProfileImageView(user: user)
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .padding(.trailing, .sm)
                
                NavigationLink(value: user) {
                    Chip(text: "@\(user.username)", style: .information)
                }
            
                if jobProposalStatus == .completed {
                    Chip(text: "Purchased", style: .success)
                } else if jobProposalStatus == .cancelled {
                    Chip(text: "Proposal Rejected", style: .cancel)
                } else if jobProposalStatus == .pending {
                    Chip(text: "Proposal Pending", style: .pending)
                }
                
                
            }
        }
    }
    
    @ViewBuilder
    var cardTitle: some View {
        
        Text("\(viewModel.job.category)")
            .textCase(.uppercase)
            .font(Style.font.title)
            .foregroundColor(Color.foreground)
            .multilineTextAlignment(.leading)
            
    }
    
    @ViewBuilder
    var cardImage: some View {
        ZStack(alignment: .topTrailing) {
            
            ImageCarousel(urls: viewModel.job.imageUrls, padding: .init(top: 0, leading: horizontalPadding, bottom: 0, trailing: horizontalPadding))
                .pageControllerOffset(x: 35 + 12) //(Card price overlay height)/2 + padding [12]
            
            Text("\u{2192}") //Side arrow (􀰑)
                .font(Style.font.title2)
                .padding(.top, .lg)
                .padding(.trailing, .lg)
                .foregroundColor(Color.background)
            
        }
        
    }
    
    @ViewBuilder
    var cardPriceOverlay: some View {
        
            
            HStack {
                Spacer()
                VStack {
                    Text("$\(viewModel.job.task)")
                        .font(Style.font.caption)
                    Text("task")
                        .font(Style.font.caption2)
                }
                Spacer()
                Divider().frame(width: 1).overlay(Color.background)
                Spacer()
                VStack {
                    Text("$\(viewModel.job.hr)")
                        .font(Style.font.caption)
                    Text("hour")
                        .font(Style.font.caption2)
                }
                Spacer()
                Divider().frame(width: 1).overlay(Color.background)
                Spacer()
                VStack {
                    Text("$\(viewModel.job.storyPost)")
                        .font(Style.font.caption)
                    Text("story")
                        .font(Style.font.caption2)
                }
                Spacer()
            }
            .frame(width: 260, height: 70)
            .foregroundColor(Color.background)
            .background(RoundedRectangle(cornerRadius: .cornerS).stroke(Color.background, lineWidth: 4).background(RoundedRectangle(cornerRadius: .cornerS).fill(Color.primary)))
            
    }
    
    @ViewBuilder
    var cardBio: some View {
        Text("\(viewModel.job.jobBio)")
            .font(Style.font.body)
            .foregroundColor(Color.foreground)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
    }
    
    @ViewBuilder
    var cardAddress: some View {
        HStack {
            Spacer()
            Text("\(viewModel.job.city), \(viewModel.job.state)")
                .font(Style.font.body2)
                .foregroundColor(Color.lightBackground)
            Spacer()
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat.sm) {
            if headerHidden == false {
                cardHeader
            }
            cardTitle
                .padding(.bottom, .xxsm)
           
       
            ZStack(alignment: .bottom) {
                NavigationLink(value: linkVal) {
                    cardImage
                }
                cardPriceOverlay
                    .offset(y: .xlg) //cardPriceOverlay.height/2
            }
            cardBio
                .padding(.top, .xlg) //cardPriceOverlay.height/2
                .padding(.horizontal, .lg)
            cardAddress
        }
        .foregroundColor(Color.background)
        .padding(.horizontal, horizontalPadding)
        
    }
}

extension JobRow {
    public func hideHeader() -> some View {
        var view = self
        view.headerHidden = true
        return view
    }
}
struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        
        JobRow(jobProposalStatus: .completed, viewModel: FeedRowViewModel(job: dev.jobs[3]))
        
    }
}


