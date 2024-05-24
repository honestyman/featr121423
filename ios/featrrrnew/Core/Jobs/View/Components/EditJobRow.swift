//
//  EditJobCell.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/14/24.
//

import SwiftUI



struct EditJobRow: View {
    // Public
    @ObservedObject var viewModel: FeedRowViewModel
    @EnvironmentObject var jobListViewModel: JobListViewModel
    // State
    @State private var bottomSheet = false
    @State private var selectedImageIndex = 0
    @State private var showEditJob = false
    
    // Private
    private let horizontalPadding: CGFloat = 36
    
    init(viewModel: FeedRowViewModel) {
        self.viewModel = viewModel
        
    }
    
    
    @ViewBuilder
    var cardTitle: some View {
        
        Text("\(viewModel.job.category)")
            .textCase(.uppercase)
            .font(Style.font.title4)
            .foregroundStyle(Color.foreground)
            .multilineTextAlignment(.leading)
            
    }
    
    @ViewBuilder
    var cardImage: some View {
        ZStack(alignment: .topTrailing) {
            
            ImageCarousel(urls: viewModel.job.imageUrls, padding: .init(top: 0, leading: horizontalPadding, bottom: 0, trailing: horizontalPadding))
                .pageControllerOffset(x: 25 + 12) //(Card price overlay height)/2 + padding [12]
            
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 20, height: 20)
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
            .frame(width: 200, height: 60)
            .foregroundColor(Color.background)
            .background(RoundedRectangle(cornerRadius: .cornerS).stroke(Color.background, lineWidth: 4).background(RoundedRectangle(cornerRadius: .cornerS).fill(Color.primary)))
            
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat.sm) {
            
            ZStack(alignment: .bottom) {
                Button {
                    showEditJob = true
                } label: {
                    cardImage
                }
                cardPriceOverlay
                    .offset(y: 30) //cardPriceOverlay.height/2
            }
            .padding(.bottom, .xlg)
            
            cardTitle
                .padding(.horizontal, .lg)

        }
        .foregroundColor(.background)
        .padding(.horizontal, horizontalPadding)
        .sheet(isPresented: $showEditJob){
            EditJobView(job: viewModel.job, showingSelfAsPopup: $showEditJob).environmentObject(jobListViewModel)
        }
        
    }
}

struct EditJobRow_Preview: PreviewProvider {
    static var previews: some View {
        
        EditJobRow(viewModel: FeedRowViewModel(job: dev.jobs[3]))
        
    }
}

