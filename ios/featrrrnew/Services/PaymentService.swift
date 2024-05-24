//
//  PaymentService.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/18/24.
//

import Foundation
import StripePaymentSheet
import StripePaymentsUI


protocol PaymentServiceDelegate {
    func preparePaymentSheet(payment:Double, job:JobPost, toUser: User, completion: @escaping (Result<PaymentSheet, Error>) -> ())
    func requstRefund(jobID: String) async -> Result<String, any Error>
    
}

struct StripeCustomer {
    var customerID: String
    var ephemerialKey: String
}

struct CardInfo {
    var id: String
    var last4: String
}
//TODO: Needs a lot of work to abstract away enviornment variables
class PaymentService: PaymentServiceDelegate {
    
    public static let standard = PaymentService()
    
    private func fetchRefreshToken(completion: @escaping (String) -> ()){
        Task {
            completion((try? await AuthService.shared.userSession?.getIDToken()) ?? "")
        }
    }
    
    func getDefaultPayment(user: User, completion: @escaping (Result<CardInfo?, Error>) -> ()) {
        
        guard let url = URL(string: FirebaseFunctions.DEFAULT_PAYMENT) else {
            print("URL invalid")
            return
        }
        
        print(user.email)
        let json = """
        {
            "email": "\(user.email)"
        }
        """
        
        // Formulate the job data
        let parameters = json.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters
        
    
        var task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                completion(.failure("There was an issue when capturing the data for our payment service"))
                return
            }
            
            print(json)
            guard let paymentId = json["id"] as? String, let last4 = json["last_4"] as? String else {
                completion(.failure("There was an issue when decoding the json data for the payment service"))
                return
            }
            
            guard let  self = self else {
                completion(.failure("Self was deallocated"))
                return
            }
            completion(.success(CardInfo(id: paymentId, last4: last4)))

        })
        task.resume()
        
    }
    func updateDefaultPaymentMethod(completion: @escaping (Result<Bool, Error>) -> ()) {
        
        fetchRefreshToken { token in
            let tokenID = "Bearer \(token)"
            var request = URLRequest(url: URL(string: FirebaseFunctions.FETCH_DEFAULT_PAYMENT_METHODS)!)
            request.allHTTPHeaderFields = ["Authorization": tokenID,"Content-Type":"application/json"]
            request.httpMethod = "get"
            
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completion(.failure("There was an issue when capturing the data for our payment service"))
                    return
                }
                print(json)
                guard let self = self else {
                    completion(.failure("Self was deallocated"))
                    return
                }
                
                if let success = json["success"] as? Int {
                    DispatchQueue.main.async {
                        completion(.success(success == 1))
                    }
                } else {
                    completion(.failure("No `success` field was passed into the API"))
                }
            })
            task.resume()
        }
        
    }
    
    func fetchDefaultPaymentMethod(completion: @escaping (Result<Bool, Error>) -> ()) {
        fetchRefreshToken { token in
            let tokenID = "Bearer \(token)"
            var request = URLRequest(url: URL(string: FirebaseFunctions.FETCH_DEFAULT_PAYMENT_METHODS)!)
            request.allHTTPHeaderFields = ["Authorization": tokenID,"Content-Type":"application/json"]
            request.httpMethod = "get"
            
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completion(.failure("There was an issue when capturing the data for our payment service"))
                    return
                }
                print(json)
                guard let self = self else {
                    completion(.failure("Self was deallocated"))
                    return
                }
                
                if let success = json["success"] as? Int {
                    DispatchQueue.main.async {
                        completion(.success(success == 1))
                    }
                } else {
                    completion(.failure("No `success` field was passed into the API"))
                }
            })
            task.resume()
        }
        
    }
    func prepareSetupIntent(user: User, completion: @escaping (Result<CustomerSheet, Error>) -> ()) {
        
        guard let url = URL(string: FirebaseFunctions.CREATE_SETUP_INTENT) else {
            print("URL invalid")
            return
        }
        
        let json = """
        {
            "email": "\(user.email)",
            "userId": "\(user.id)"
        }
        """
        // Formulate the job data
        let parameters = json.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters
        
        print("Sending data")
        var task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                completion(.failure("There was an issue when capturing the data for our payment service"))
                return
            }
            
            guard let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let setupIntentDictionary = json["setupIntent"] as? [String: Any],
                  let paymentIntentClientSecret = setupIntentDictionary["client_secret"] as? String,
                  let publishableKey = json["publishableKey"] as? String else {
                completion(.failure("There was an issue when decoding the json data for the payment service"))
                return
            }
            
            guard let  self = self else {
                completion(.failure("Self was deallocated"))
                return
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            // Create a PaymentSheet instance
            var configuration = CustomerSheet.Configuration()

            // Configure settings for the CustomerSheet here. For example:
            configuration.headerTextForSelectionScreen = "Manage your payment method"
            
            let customerAdapter = StripeCustomerAdapter(customerEphemeralKeyProvider: {
                return CustomerEphemeralKey(customerId: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            }, setupIntentClientSecretProvider: {
                return paymentIntentClientSecret
            })
            
            let customerSheet = CustomerSheet(configuration: configuration, customer: customerAdapter)
            
            DispatchQueue.main.async {
                completion(.success(customerSheet))
            }
        })
        task.resume()
        
    }
    func preparePaymentSheet(payment:Double, job:JobPost, toUser user:User, completion: @escaping (Result<PaymentSheet, Error>) -> ())  {
        let _id: String = job.id!
        
        // MARK: Fetch the PaymentIntent and Customer information from the backend
        var parameters = "{\n"
        if let fullname = user.fullname {
            parameters += "\"name\": \"\(fullname)\",\n"
        } else {
            // If fullname is nil, you can provide a default name or handle it as needed.
            parameters += "\"name\": \"Default Name\",\n"
        }
        parameters += """
            "amount": \(payment),
            "email": "\(user.email)",
            "jobId": "\(_id)",
            "userId": "\(user.id)"
        }
        """
        
        Log.i("Job ID: \(parameters)")
        
        // Formulate the job data
        let jobData = parameters.data(using: .utf8)
        
        if let url = URL(string: FirebaseFunctions.CREATE_PAYMENT_INTENT) {
            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = jobData
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                    completion(.failure("There was an issue when capturing the data for our payment service"))
                    return
                }
                if let message = json["message"] as? String, let success = json["success"] as? Int, success == 0 {
                    // There was already a successful charge no need to prepare the payment sheet
                    completion(.failure(message))
                    return
                }
                
                guard let customerId = json["customer"] as? String,
                      let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                      let paymentIntentDict = json["paymentIntent"] as? [String: Any],
                      let paymentIntentClientSecret = paymentIntentDict["client_secret"] as? String,
                      let publishableKey = json["publishableKey"] as? String,
                      let self = self else {
                    
                    completion(.failure("There was an issue when decoding the json data for the payment service"))
                    return
                }
                
                STPAPIClient.shared.publishableKey = publishableKey
                // Create a PaymentSheet instance
                var configuration = PaymentSheet.Configuration()
                configuration.merchantDisplayName = "Example, Inc."
                configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
                // Set `allowsDelayedPaymentMethods` to true if your business handles
                // delayed notification payment methods like US bank accounts.
                configuration.allowsDelayedPaymentMethods = true
                
                DispatchQueue.main.async {
                    completion(.success(PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)))
                }
            })
            task.resume()
        } else {
            completion(.failure("Unable to create the URL to access the API"))
        }
    }
    
    func requstRefund(jobID: String) async -> Result<String, any Error> {
       
        guard let refreshToken = try? await AuthService.shared.userSession?.getIDToken()
        else{ return .failure("The refresh token was invalid") }
        
        let url = URL(string: "http://127.0.0.1:5001/featchr-113f6/us-central1/requestRefundPayment")
        let params: [String:String] = ["jobId":jobID]
      
        var request = URLRequest(url: url!)
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        let session = URLSession.shared
        do {
            let response = try await session.data(for: request)
            return .success("A refund was successfully posted")
        } catch {
            return .failure(error)
        }
        
    }
    
}
