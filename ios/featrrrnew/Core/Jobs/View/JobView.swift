//
//  FeedView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/27/23.
//

import SwiftUI

struct JobView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var isShowingUploadJobView = false
    @State private var isShowFilter = false
    
    @State var ft_category: String = ""
    @State var ft_city: String = ""
    @State var ft_state: String = ""
    @State var ft_country: String = ""
    
    @ViewBuilder
    var filter: some View {
        VStack(spacing: CGFloat.sm) {
            TextField("Category", text: $ft_category)
                .frame(height: 34)
            TextField("City", text: $ft_city)
                .frame(height: 34)
            TextField("State", text: $ft_state)
                .frame(height: 34)
            TextField("Country", text: $ft_country)
                .frame(height: 34)
            Button("Apply") {
                viewModel.updateFilter(category: ft_category, city: ft_city, state: ft_state, country: ft_country)
                isShowFilter.toggle()
            }
            .frame(height: 44)
        }
        .font(Style.font.caption)
        .padding()
    }
    
    @ViewBuilder
    var feed: some View {
        LazyVStack(alignment: .center, spacing: CGFloat.md) {
            ForEach(viewModel.jobs) { job in
                
                let proposalStatus = viewModel.userProposals?.first(where: { $0.jobID == job.id })?.status ?? .none
                
                JobRow(jobProposalStatus: proposalStatus, viewModel: FeedRowViewModel(job: job), linkVal: .profile(job))
                
                /// - NOTE: If the id is not set for the document and there are semantically identical IDs, they will not be rendered by the VStack as it things they are the same object
                Divider()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            if(isShowFilter) {
                filter
            }
            ScrollView {
               feed
                .padding(.top)
                .navigationDestination(for: JobLinkValue.self) { value in
                    navigateToNew(linkValue: value)
                }
                
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { self.isShowFilter.toggle() }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                }
            
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.isShowingUploadJobView.toggle()
                    }) {
                        Image(systemName: "photo.badge.plus")
                            .foregroundColor(.primary)
                    }
                }
                
                
            })
            .navigationTitle("Featrrr")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingUploadJobView){
                UploadJobView(showingSelfAsPopup: $isShowingUploadJobView).environmentObject(viewModel)
            }
            .onAppear {
                viewModel.reload()
            }
            .refreshable {
                Task {
                    do {
                        try await viewModel.fetchJobsWithUserData()
                    } catch {
                        Log.d("There was an error whenever attempting to fetch all jobs: \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }
    
    private func navigateToNew(linkValue value: JobLinkValue) -> AnyView? {
        /// - NOTE: This switch is not exhastive and does not have adaquet error handling if any values are null (just won't go to the next page)
        switch (value) {
        case .profile(let job):
            if let user = job.user {
                return AnyView(ProfileView(user: user, selectedJob: job))
            }
        case .job(let job):
            if let user = job.user {
                return AnyView(PaymentSheetView(viewModel: PaymentSheetViewModel(job: job, user: user)))
            }
        }
        return nil
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
            JobView()
    }
}
