//
//  ReviewCell.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI
import Kingfisher

struct CommentRow: View {
    let review: Review
    
    var body: some View {
        HStack {
            KFImage(URL(string: review.profileImageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
            
            Text(review.username).font(Style.font.caption) +
                Text(" \(review.reviewText)").font(Style.font.body)
            
            Spacer()
            
            Text(" \(review.timestampString ?? "")")
                .foregroundColor(Color.lightBackground)
                .font(Style.font.body2)
        }.padding(.horizontal)
    }
}
