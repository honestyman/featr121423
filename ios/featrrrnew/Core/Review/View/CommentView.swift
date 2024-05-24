//
//  ReviewsView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI

struct CommentView: View {
    @State private var reviewText = ""
    @StateObject var viewModel: CommentViewModel
    
    init(job: JobPost) {
        self._viewModel = StateObject(wrappedValue: CommentViewModel(job: job))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: CGFloat.lg) {
                    ForEach(viewModel.reviews) { review in
                        CommentRow(review: review)
                    }
                }
            }.padding(.top)
            
            CustomInputView(inputText: $reviewText, placeholder: "Review...", action: uploadReview)
        }
        .navigationTitle("Comments")
        .toolbar(.hidden, for: .tabBar)
    }
    
    func uploadReview() {
        Task {
            await viewModel.uploadReview(reviewText: reviewText)
            reviewText = ""
        }
    }
}
