//
//  StripeApiClient.swift
//  featrrrnew
//
//  Created by Abdullah's Mac Vision on 26/09/2023.
//

import Foundation
//import Stripe
//
//class MyAPIClient: NSObject, STPCustomerEphemeralKeyProvider {
//    var baseURL:String="www"
//
//    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
//        let url = self.baseURL.appendingPathComponent("ephemeral_keys")
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
//        urlComponents.queryItems = [URLQueryItem(name: "api_version", value: apiVersion)]
//        var request = URLRequest(url: urlComponents.url!)
//        request.httpMethod = "POST"
//        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//            guard let response = response as? HTTPURLResponse,
//                response.statusCode == 200,
//                let data = data,
//                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]) as [String : Any]??) else {
//                completion(nil, error)
//                return
//            }
//            completion(json, nil)
//        })
//        task.resume()
//    }
//}
