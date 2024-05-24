//
//  jobProposal.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/18/24.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

enum JobProposalStatus: String, Codable {
    case pending = "pending"
    case completed = "completed"
    case cancelled = "cancelled"
    case none = "none"
}


struct JobProposal: Identifiable, Codable {
    
    var id: String {
        return jobProposalID ?? NSUUID().uuidString
    }
    
    @DocumentID private var jobProposalID: String?
    
    let sellerID: String
    let buyerID: String
    let jobID: String
    
    let status: JobProposalStatus
    let proposal: Proposal
    let completionCost: Double?
    
    init(jobProposalID: String? = nil, sellerID: String, buyerID: String, jobID: String, status: JobProposalStatus, proposal: Proposal, completionCost: Double? = nil) {
        self.jobProposalID = jobProposalID
        self.sellerID = sellerID
        self.buyerID = buyerID
        self.jobID = jobID
        self.status = status
        self.proposal = proposal
        self.completionCost = completionCost
    }
    
    enum CodingKeys: String, CodingKey {
        case jobProposalID
        case sellerID
        case buyerID
        case jobID
        case status
        case proposal
        case completionCost
    }
}
