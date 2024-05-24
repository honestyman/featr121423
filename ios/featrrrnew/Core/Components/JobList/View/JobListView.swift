//
//  JobListView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI
import Kingfisher

struct JobListView: View {
    
    @State var isJobUpdated: Bool = false
    @State private var isLoading = true
    @ObservedObject var viewModel: JobListViewModel
    
    
    init(user: User) {
        viewModel = JobListViewModel(user: user)
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: CGFloat.xlg) {
            HStack(spacing: CGFloat.lg) {
                Text("Active Jobs")
                    .font(Style.font.title2)
                    .foregroundColor(.foreground)
                    .padding(.horizontal, .xlg)
                if isLoading {
                    ProgressView()
                }
            }
            
            ForEach(viewModel.jobs) { job in
                
                EditJobRow(viewModel: FeedRowViewModel(job: job))
                    .environmentObject(viewModel)
                    .padding(.bottom, .sm)
                    .onAppear {
                        isLoading = false //As soon as any cell displays, clear loading indicator
                    }
                Divider()
                    .padding(.bottom, .sm)
                
            }
            
        }
        .onChange(of: isJobUpdated, perform: { _ in
            viewModel.reload()
        })
    }
}

struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        JobListView(user: dev.user)
    }
}
