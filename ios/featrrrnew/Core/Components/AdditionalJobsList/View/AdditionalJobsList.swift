//
//  NotCurrentUserJobListView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/8/23.
//

import SwiftUI
import Kingfisher


/// Automatically discludes the selected job from the job list
struct AdditionalJobsList: View {

    @StateObject var viewModel: FeedProfileViewModel
    @Binding var selectedJob: JobPost?
              
    var content: some View {
        LazyVStack(spacing: CGFloat.lg) {
            ForEach(viewModel.jobs) { job in
                
                if job != selectedJob {
                    
                    MinifiedFeedCell(viewModel: FeedRowViewModel(job: job), selectedJob: $selectedJob)
                        .padding(.bottom, .sm)
                    Divider()
                } // The job is the selected job and should not be shown
                
               
                
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // Account for the displayed job being listed
            if viewModel.jobs.count > 1 {
                Text("\(viewModel.jobs.count - 1) Available Jobs From This User")
                    .font(Style.font.title2)
                    .padding(.leading, .lg)
                Divider()
                content
            } else {
                Text("No Additional Jobs Available")
            }
        }
    }
}

struct NotCurrentUserJobListView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalJobsList(viewModel: FeedProfileViewModel(user: dev.user), selectedJob: .constant(nil))
    }
}
