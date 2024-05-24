//
//  ContentView.swift
//  SwiftUIProject
//
//  Created by CodistanVentures on 10/29/23.
//

import SwiftUI
import Kingfisher
import StripePaymentSheet
import StripePaymentsUI

enum CardSelectedMode: Int {
    case pending, completed
}

struct PaymentView: View {
    
    @ObservedObject var paymentViewModel = PaymentViewModel()
    
    @ViewBuilder
    var pendingView: some View {
        if paymentViewModel.isLoading == true {
            ProgressView()
        } else {
            if paymentViewModel.pendingRequests.count <= 0 {
                Text("Go send some invites for jobs!")
                    .foregroundColor(Color.lightBackground)
            } else {
                ScrollView {
                    ForEach(paymentViewModel.pendingRequests) { request in
                        PendingListItemView(
                            viewModel: PendingListItemViewModel(jobProposal: request, paymentViewModel: paymentViewModel))
                        Divider()
                    }
                }.padding(.horizontal, .lg)
            }
        }
    }
    
    @ViewBuilder
    var completedView: some View {
        if paymentViewModel.isLoading == true {
            ProgressView()
        } else {
            if paymentViewModel.completedRequests.count <= 0 {
                Text("No completed jobs yet")
                    .foregroundColor(Color.lightBackground)
            } else {
                ScrollView {
                    ForEach(paymentViewModel.completedRequests) { request in
                        CompletedListItemView(
                            viewModel: CompletedListItemViewModel(jobProposal: request, paymentViewModel: paymentViewModel))
                        Divider()
                    }
                }.padding(.horizontal, .lg)
            }
        }
    }
    var body: some View {
        
        ZStack {
            GeometryReader{ proxy in
                
                VStack(alignment: .center) {
                    //MARK: Navigationbar
                    navBar
                        .padding(.leading,.lg)
                        .padding(.bottom,.md)
                    
                    HStack(spacing:0){
                        
                        Picker("Select your payment review?", selection: $paymentViewModel.selectedMode) {
                            Text("Pending").tag(CardSelectedMode.pending)
                            Text("Completed").tag(CardSelectedMode.completed)
                            
                        }
                        .pickerStyle(.segmented)
                    }.padding()
                    
                    Spacer()
                    if paymentViewModel.isLoading{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if paymentViewModel.selectedMode == .pending {
                        pendingView
                    } else if paymentViewModel.selectedMode == .completed {
                        completedView
                    }
                    Spacer()
                }
                
            }
            
            VStack {
                if paymentViewModel.popoverStatus == .completed {
                    Text("Completed Payment!")
                } else if paymentViewModel.popoverStatus == .cancelled {
                    Text("Cancelled Successfully")
                }
            }
            .frame(width: 250, height: 150)
            .background(.ultraThinMaterial)
            .mask(RoundedRectangle(cornerRadius: .cornerM))
            .opacity(paymentViewModel.displayPopoverOpacity)
            .animation(.easeIn(duration: 0.25), value: paymentViewModel.displayPopoverOpacity)
            
        }
        .alert(isPresented: $paymentViewModel.showError, content: {
            Alert(title: Text(paymentViewModel.errorMessage))
        })
        .task {
            await paymentViewModel.fetchPendingRequests()
        }.onChange(of: paymentViewModel.selectedMode, perform: { value in
            Task {
                switch (paymentViewModel.selectedMode) {
                case .pending:
                    await paymentViewModel.fetchPendingRequests()
                case .completed:
                    await paymentViewModel.fetchCompletedRequests()
                }
            }
        }).onChange(of: paymentViewModel.displayPopoverOpacity) { value in
            if value == 1.0 {
                //Fade out after a specified duration
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { // possibly a risk for a strong reference cycle
                    self.paymentViewModel.displayPopoverOpacity = 0.0
                })
            }
        }
    }
    
    var navBar: some View{
        HStack(alignment: .center,spacing: 0){
            Text("Payments")
                .font(Style.font.title)
                .foregroundColor(.foreground)
                .padding(.leading,.md)
                
            Spacer()
        }
    }
}


struct RefundListItem: View{
    
    let refundRequest: RefundRequest
    let onRefundButtonTapped: (RefundRequest) async -> Void
    let proxy: GeometryProxy
    let isRefundButtonDisabled: Bool
    
    var body: some View{
        HStack {
            Spacer()
            VStack(alignment: .leading){
                KFImage(URL(string: refundRequest.job.imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width * 0.8)
                    .frame(height: proxy.size.width * 0.8)
                    .clipShape(RoundedRectangle(cornerRadius: .cornerS))
                    
                Text(refundRequest.job.category)
                Text(refundRequest.job.city)
                Text(refundRequest.job.jobBio)
                    .lineLimit(2)
                Button {
                    if isRefundButtonDisabled && refundRequest.status == .pending{
                        Task{
                            await onRefundButtonTapped(refundRequest)
                        }
                    }
                } label: {
                    Text(refundRequest.status.rawValue.capitalized)
                        .foregroundColor(Color.background)
                        .padding(.sm)
                        .frame(width: proxy.size.width * 0.8)
                        .background{
                            RoundedRectangle(cornerRadius: .cornerS)
                                .foregroundColor(refundRequest.status == .pending ? Color.warning : .secondary)
                                .shadow(color: Color.lightBackground, radius: 2)
                            
                        }
                }
               
            }
            .padding(.md)
            .background{
                RoundedRectangle(cornerRadius: .cornerS)
                    .foregroundColor(.background)
                    .shadow(color: .background, radius: 2)
        }
            Spacer()
        }
    }
}
        


struct RefundView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
