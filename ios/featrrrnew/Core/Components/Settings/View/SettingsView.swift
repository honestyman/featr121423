//
//  SettingsView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/11/23.
//

import SwiftUI
import StripePaymentSheet

enum SettingsItemModel: Int, Identifiable, Hashable, CaseIterable {
    case settings
    case saved
    case logout
    
    var title: String {
        switch self {
        case .settings:
            return "Settings"
        case .saved:
            return "Saved"
        case .logout:
            return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .settings:
            return "gear"
        case .saved:
            return "bookmark"
        case .logout:
            return "arrow.left.square"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum PaymentState {
    case noPaymentMethod, paymentOnFile, paymentError, paymentLoading
}
class SettingsViewModel: ObservableObject {
    @Published var customerSheet: CustomerSheet?
    @Published var paymentState: PaymentState = .paymentLoading

    init() {
        getCustomerSheet()
        getDefaultPayment() //Load the initial payment method to populate with "default" (no payment, error, payment)
    }
    func getCustomerSheet() {
        if let user = AuthService.shared.user {
            PaymentService.standard.prepareSetupIntent(user: user) { result in
                
                do {
                    let sheet = try result.get()
                    self.customerSheet = sheet
                } catch {
                    print("ERROR \(error)")
                    //TODO: Display error in model
                }
                
            }
        } else {
            print("no user")
        }
    }
      func onCompletion(result: CustomerSheet.CustomerSheetResult) {
          switch (result){
          case .canceled(let selection), .selected(let selection):
              if selection == nil {
                  paymentState = .noPaymentMethod
              } else {
                  paymentState = .paymentOnFile
              }
          case .error(let error):
              paymentState = .paymentError
          }
      }
    
    func getDefaultPayment() {
        if let user = AuthService.shared.user {
            PaymentService.standard.getDefaultPayment(user:user) {result in
                do {
                    let result = try result.get()
                    if result == nil {
                        self.paymentState = .noPaymentMethod
                    } else {
                        self.paymentState = .paymentOnFile
                    }
                } catch {
                    self.paymentState = .paymentError
                }
                
            }
        }
        
    }
      
    
}
struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingCustomerSheet = false
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack {
            
            Divider()
            
            List {
               
                    Button {
                        viewModel.getDefaultPayment()
                        showingCustomerSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "creditcard.fill")
                            Text("Payment Settings")
                            
                                Spacer()
                                switch (viewModel.paymentState) {
                                case .paymentLoading:
                                    ProgressView()
                                case .paymentError:
                                    Chip(text: "Error", style: .cancel)
                                case .noPaymentMethod:
                                    Chip(text: "No Payment Method", style: .information)
                                case .paymentOnFile:
                                    Chip(text: "Payment On File", style: .success)
                                }
                            
                        }
                    }

                Button {
                    print("Toggle the Dark Mode")
                } label: {
                    HStack {
                        Image(systemName: "circle.lefthalf.filled")
                        Text("Toggle Dark Mode")
                    }
                }
                
                Button {
                    AuthService.shared.signout()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.square")
                        Text("Logout")
                    }
                }

               
            }
            .listStyle(PlainListStyle())
            
            if let sheet = viewModel.customerSheet {
                VStack{}.customerSheet(
                    isPresented: $showingCustomerSheet,
                    customerSheet: sheet,
                    onCompletion: viewModel.onCompletion)
            }
        }.navigationTitle("Settings")
    }
}

struct SettingsRowView: View {
    let model: SettingsItemModel
    
    var body: some View {
        HStack(spacing: CGFloat.sm) {
            Image(systemName: model.imageName)
                .imageScale(.medium)
            
            Text(model.title)
                .font(Style.font.title2)
                .foregroundColor(.background)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
