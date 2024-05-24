//
//  SwiftUIView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/27/23.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    let user: User
    
    @StateObject var viewModel: FeedProfileViewModel
    @State var selectedJob: JobPost?
    
    init(user: User, selectedJob: JobPost? = nil) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: FeedProfileViewModel(user: user))
        self._selectedJob = State(initialValue: selectedJob)
        
    }
    @Namespace var topID
    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
           
            VStack(spacing: CGFloat.lg) {
                    
                    MinifiedProfileHeaderView(viewModel: viewModel)
                    .padding(.horizontal, CGFloat.lg).id(topID)
                    Divider()
                    if let job = selectedJob {
                        
                        JobRow(jobProposalStatus:  .none, viewModel: FeedRowViewModel(job: job), margin: 50, linkVal: .job(job))
                            .hideHeader()
                        
                        //TODO:
                    }
                    Divider()
                    //IF there are any availabe jobs for the user, show
                    AdditionalJobsList(viewModel: viewModel, selectedJob: $selectedJob)
                    
                }
                .onChange(of: selectedJob, perform: { value in
                    withAnimation {
                        proxy.scrollTo(topID)
                    }
                    
                })
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
