//
//  Payment.swift
//  featrrrnew
//
//  Created by Abdullah's Mac Vision on 25/09/2023.
//

import SwiftUI
import Stripe
import StripePaymentsUI

struct Payment: View {
    var paymentIntentClientSecret: String = "pi_3NuUfhHPhoixtOLj1u19joKD_secret_NBz0s9jzLBttSAv7q2DmOwdoe"
    
    @State var cardTextField: STPPaymentCardTextField = {
            let cardTextField = STPPaymentCardTextField()
            return cardTextField
        }()

    
    func pay() {
//            guard let paymentIntentClientSecret = paymentIntentClientSecret else {
//                return
//            }
            // Collect card details
            let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
            paymentIntentParams.paymentMethodParams = cardTextField.paymentMethodParams

            // Submit the payment
//            let paymentHandler = STPPaymentHandler.shared()
//            paymentHandler.confirmPayment(paymentIntentParams, with: self) { (status, paymentIntent, error) in
//                switch (status) {
//                case .failed:
//                    self.displayAlert(title: "Payment failed", message: error?.localizedDescription ?? "")
//                    break
//                case .canceled:
//                    self.displayAlert(title: "Payment canceled", message: error?.localizedDescription ?? "")
//                    break
//                case .succeeded:
//                    self.displayAlert(title: "Payment succeeded", message: paymentIntent?.description ?? "", restartDemo: true)
//                    break
//                @unknown default:
//                    fatalError()
//                    break
//                }
//            }
        }
    
    
//    func choosePaymentButtonTapped() {
//        self.paymentContext.presentPaymentOptionsViewController()
//    }
    
    var body: some View {
        
        HStack {
            Button("Hello") {
                print("hello")
                pay()
            }
            .padding(.all)
            .background(Color.black)
            .cornerRadius(20)
        }
    }
}

struct Payment_Previews: PreviewProvider {
    static var previews: some View {
        Payment()
    }
}
