//
//  RefundRepository.swift
//  SwiftUIProject
//
//  Created by CodistanVentures on 10/30/23.
//

import Foundation

protocol RefundProtocol{
    func fetchRequestsBuyer() async throws -> [RefundRequest]
    func fetchRequestSeller() async throws -> [RefundRequest]
    func approveRefund(id: String) async throws -> Bool
}

final class RefundService: RefundProtocol{
   
    public static let standard = RefundService()
    
    struct HttpReundRepositoryError: Error,LocalizedError{
        var errorDescription: String?{
            return "Oops something went wrong"
        }
    }
    
    private func fetchRefresToken() async -> String{
        (try? await AuthService.shared.userSession?.getIDToken()) ?? ""
    }
    
    func fetchRequestsBuyer() async throws -> [RefundRequest] {
        
        let tokenID = "Bearer \(await fetchRefresToken())"
        var urlRequest = URLRequest(url: URL(string: "https://getbuyerrefundrequests-7tciwcgjna-uc.a.run.app")!)
        urlRequest.allHTTPHeaderFields = ["Authorization": tokenID,"Content-Type":"application/json"]
        urlRequest.httpMethod = "get"
        let session = URLSession.shared
        let (data,response) = try await session.data(for: urlRequest)
        
        if let httpResponse = (response as? HTTPURLResponse),
           httpResponse.statusCode == 200
        {
            do{
                let jsonDecodedResponse = try JSONDecoder().decode(RefundRequestDTO.self, from: data)
                return jsonDecodedResponse.refundRequests ?? []
            }
            catch let error{
                
                throw error
            }
        }
        throw HttpReundRepositoryError()
    }
    
    func fetchRequestSeller() async throws -> [RefundRequest] {
        let tokenID = "Bearer \(await fetchRefresToken())"
        var urlRequest = URLRequest(url: URL(string: "https://getrefundrequests-7tciwcgjna-uc.a.run.app")!)
        urlRequest.allHTTPHeaderFields = ["Authorization": tokenID,"Content-Type":"application/json"]
        urlRequest.httpMethod = "get"
        let session = URLSession.shared
        let (data,response) = try await session.data(for: urlRequest)
        if let httpResponse = (response as? HTTPURLResponse),
           httpResponse.statusCode == 200,
           let jsonDecodedResponse = try? JSONDecoder().decode(RefundRequestDTO.self, from: data)
        {
            return jsonDecodedResponse.refundRequests ?? []
        }
        throw HttpReundRepositoryError()
    }
    
    func approveRefund(id: String) async throws -> Bool {
        let tokenID = "Bearer \(await fetchRefresToken())"
        var urlRequest = URLRequest(url: URL(string: "https://confirmrefundrequest-7tciwcgjna-uc.a.run.app")!)
        urlRequest.httpMethod = "job"
        urlRequest.allHTTPHeaderFields = ["Authorization": tokenID,"Content-Type":"application/json"]
        let body = ["requestId": id]
       
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let session = URLSession.shared
        let (_,response) = try await session.data(for: urlRequest)
      
        if let httpResponse = (response as? HTTPURLResponse),
           httpResponse.statusCode == 200
        {
            return true
        }else{ throw HttpReundRepositoryError() }
    }
    
    func fetchPendingRequests(){
        
    }
    
}

