//
//  FeedRowViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import SwiftUI
import Firebase

@MainActor
class FeedRowViewModel: ObservableObject {
    @Published var job: JobPost
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: job.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    init(job: JobPost) {
        self.job = job
        
    }
}
    
    
   
    
  
