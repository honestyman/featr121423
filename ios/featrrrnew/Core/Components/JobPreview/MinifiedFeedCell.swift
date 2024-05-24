//
//  MinifiedFeedCell.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/20/24.
//

import SwiftUI


struct MinifiedFeedCell: View {
    // Public
    @ObservedObject var viewModel: FeedRowViewModel
    @Binding var selectedJob: JobPost?
    // State
    @State private var bottomSheet = false
    @State private var selectedImageIndex = 0
    
    // Private
    private let horizontalPadding: CGFloat = 28
    
    init(viewModel: FeedRowViewModel, selectedJob: Binding<JobPost?>) {
        self.viewModel = viewModel
        self._selectedJob = selectedJob
    }
    
    @ViewBuilder
    var cardHeader: some View {
        
        if let user = viewModel.job.user {
            HStack(spacing: 0) {
                CircularProfileImageView(user: user)
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
                    .padding(.trailing, .lg)
                
                NavigationLink(value: user) {
                    Chip(text: "@\(user.username)", style: .information)
                }
            }
        }
    }
    
    @ViewBuilder
    var cardTitle: some View {
        
        
            Text("\(viewModel.job.category)")
                .textCase(.uppercase)
                .font(Style.font.title3)
                .foregroundColor(Color.foreground)
                .multilineTextAlignment(.leading)
                .lineLimit(3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
       
    }

    @ViewBuilder
    var cardImage: some View {
        
       
            
            ZStack(alignment: .topTrailing) {
               
                
                   
                        ImageCarousel(urls: viewModel.job.imageUrls, padding: .init(top: 0, leading: horizontalPadding, bottom: 0, trailing: horizontalPadding))
                            .preview()
                            .pageControllerOffset(x: 12)
                           
                
                Text("\u{2192}") //Side arrow (􀰑)
                    .font(Style.font.title2)
                    .padding(.sm)
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
            .foregroundColor(Color.background)
            .background(RoundedRectangle(cornerRadius: .cornerS).fill(Color.primary))
            .frame(maxWidth: .infinity)
            
    }
    
    @ViewBuilder
    var cardBio: some View {
        Text("\(viewModel.job.jobBio)")
            .font(Style.font.caption)
            .multilineTextAlignment(.leading)
            .lineLimit(1)
    }
    

    var body: some View {
        Button(action: {
            selectedJob = viewModel.job
        }, label: {
            VStack(alignment: .leading) {
                
                HStack(spacing: CGFloat.md) {
                    cardImage
                    VStack {
                        cardTitle
                        cardPriceOverlay
                    }.frame(maxHeight: 120)
                }
            }
            .padding(.horizontal, horizontalPadding)
        })
        
    }
}

struct MinifiedFeedCell_Previews: PreviewProvider {
    static var previews: some View {
        
        MinifiedFeedCell(viewModel: FeedRowViewModel(job: dev.jobs[3]), selectedJob: .constant(nil))
        
    }
}


