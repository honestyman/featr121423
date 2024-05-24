//
//  JobProposalService.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/18/24.
//

import Foundation
import Firebase

class JobProposalService {
    
    public static let standard = JobProposalService()
    
    func getProposal(from proposalID: String, completion: @escaping (Result<JobProposal, Error>) -> ()) {
        FirestoreConstants.JobProposalCollection.document(proposalID).getDocument { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            if let proposal = try? snapshot?.data(as: JobProposal.self ) {
                completion(.success(proposal))
                return
            } else {
                Log.d("Unable to decode the JobProposal for the proposal \(proposalID)")
                completion(.failure("Unable to decode the JobProposal"))
                return
            }
        }
        
        
    }
    
    func cancel(proposalId: String, completion: @escaping (Result<Any, Error>) -> ()) {
        let jobProposalDocument = FirestoreConstants.JobProposalCollection.document(proposalId)
        let updateField: [String: String] = [JobProposal.CodingKeys.status.rawValue: JobProposalStatus.cancelled.rawValue]
        
        jobProposalDocument.updateData(updateField) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true)) //TODO: Possibly add in actual
            }
        }
    }
    func complete(proposalId: String, completionCost cost: Double, completion: @escaping (Result<Any, Error>) -> ()) {
        let jobProposalDocument = FirestoreConstants.JobProposalCollection.document(proposalId)
        let updateField: [String: Any] = [
            JobProposal.CodingKeys.status.rawValue: JobProposalStatus.completed.rawValue,
            JobProposal.CodingKeys.completionCost.rawValue: cost]
        
        jobProposalDocument.updateData(updateField) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true)) //TODO: Possibly add in actual
            }
        }
    }
    func getProposals(forUserID userID: String, selection: PaymentSelection? = nil, completion: @escaping (Result<[JobProposal], Error>) -> ()) {
        var query = FirestoreConstants.JobProposalCollection.whereField("buyerID", isEqualTo: userID)
        
        if let selection {
            query = query.whereField("status", isEqualTo: selection.rawValue)
        }
        
        query.getDocuments { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            var bids: [JobProposal] = []
            if let documents = snapshot?.documents {
                for doc in documents {
                    do {
                        let proposal = try doc.data(as: JobProposal.self )
                        bids.append(proposal)
                    } catch {
                        Log.d("Unable to decode the JobProposal with error \(error.localizedDescription)")
                    }
                }
            }
            completion(.success(bids))
        }
        
        
    }
    func sendJobProposal(forJob job: JobPost, withJob bid: Proposal, status: JobProposalStatus = .pending) -> Result<String?, Error> {
        
        let jobProposalDocument = FirestoreConstants.JobProposalCollection.document()
            
        guard let buyerID = Auth.auth().currentUser?.uid else {
            return .failure("The buyer's ID was unaccessible")
        }
        guard let sellerID = job.user?.uid else {
            return .failure("The seller's ID was unaccessible")
        }
        guard let jobID = job.id else {
            return .failure("The job ID was unaccessible")
        }
        
        if (bid.hourly == nil && bid.task == nil && bid.story == nil ) {
            return .failure("The bid returned did not have an hourly, task, or story bid attached")
        }
        
        let jobProposal = JobProposal(sellerID: sellerID, buyerID: buyerID, jobID: jobID, status: status, proposal: bid)
        
        guard let encodedJobProposal = try? Firestore.Encoder().encode(jobProposal) else {
            return .failure("We were unable to encode the job bid")
        }
        
        jobProposalDocument.setData(encodedJobProposal)
        
        return .success(jobProposalDocument.documentID)
    }
}
