//
//  PaymentSheetView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/6/23.
//

import SwiftUI
import StripePaymentSheet
import StripePaymentsUI
import Kingfisher
import Firebase



struct PaymentSheetView: View {
    
    
    var closedRange = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    
    @State private var isEditing = false
    
    @State private var showTextField = false
    
    @State private var messageText = ""
    
    @State private var showBottomSheet = false
    
    @StateObject var viewModel: PaymentSheetViewModel
    
    
    var _currentUser: User? {
        guard let user = AuthViewModel.shared.currentUser else {
            return nil
        }
        return user
    }
    
    var header: some View {
        VStack {
            ImageCarousel(urls: viewModel.job.imageUrls, padding: .init(top: 10, leading: 28, bottom: 10, trailing: 28))
            Text(viewModel.job.category)
        }
    }
    var requestRefund: some View {
        VStack {
            
            Divider()
            
            Text("You've already purchased this service")
                .font(Style.font.title4)
                .cornerRadius(.cornerS)
                .padding(.vertical, .lg)
            
            Text("Contact Support to Request a Refund")
                .font(Style.font.title4)
                .foregroundColor(Color.primary)
                .cornerRadius(.cornerS)
                .padding(.bottom, .lg)
        }
    }
    
    var jobToggle: some View {
        VStack{
            Form {
                if !viewModel.hourlyOn {
                    Toggle("Hourly - $\(viewModel.job.hr)", isOn: $viewModel.hourlyOn)
                    
                }
                else {
                    Section(header: Text("Hourly is usually done together with the hirer, and paid based on time. Choose a day and time  to begin working together.")) {
                        DatePicker("Hourly - $\(viewModel.job.hr)", selection: $viewModel.currentTimeHr, in: Date()...)
                        
                        DatePicker("End Time", selection: $viewModel.endTimeHr, displayedComponents: .hourAndMinute)
                        
                        
                        Toggle("", isOn: $viewModel.hourlyOn)
                    }
                }
                
                
                if !viewModel.taskOn {
                    Toggle("Task - $\(viewModel.job.task)", isOn: $viewModel.taskOn)
                }
                else {
                    Section(header: Text("Task are generally done apart from the hirer, recorded content associated with the talent's category and sent back to the hirer to be featrrred. Choose what day you want this task completed and sent to you.")) {
                        DatePicker("Task - $\(viewModel.job.task)", selection: $viewModel.currentTimeTask, displayedComponents: .date)
                        
                        Toggle("", isOn: $viewModel.taskOn)
                    }
                }
                
                
                if !viewModel.storyOn {
                    Toggle("Story job - $\(viewModel.job.storyPost)", isOn: $viewModel.storyOn)
                    
                }
                else {
                    Section(header: Text("All story job are to last a minimum of 24hrs. Choose a day and time you would like this talent to job you and you can specify on which platform you'd like to be posted (prices usually reflect the best of their  socialmedia).")) {
                        DatePicker("Story job - $\(viewModel.job.storyPost)", selection: $viewModel.currentTimeStoryPost, in: Date()...)
                        
                        Toggle("", isOn: $viewModel.storyOn)
                    }
                }
            }
            .frame(height: 200)
            .cornerRadius(8)
            
        }
        .padding()
    }
    var body: some View {
        if viewModel.isLoading{
            ProgressView()
        }else{
            ScrollView{
                VStack {
                    
                    header
                    
                    if let paidUser = viewModel.job.paidUsers, paidUser.contains(where: { value in
                        value == Auth.auth().currentUser?.uid ?? ""}) {
                        requestRefund
                    } else {
                        jobToggle
                    }
                    
                }
                .sheet(isPresented: $showBottomSheet) {
                    ChatViewPopover(user: viewModel.user)
                }
                
                if let cost = viewModel.formattedCost {
                    Button (action: {
                        
                        Task {
                            Log.i("Recieved a Job Bid")
                            await viewModel.sendJobProposal()
                            showBottomSheet.toggle()
                        }
                        
                        
                    })
                    {
                        Text("Send Proposal for \(cost)")
                            .font(Style.font.caption)
                            .foregroundColor(Color.background)
                            .frame(width: 360, height: 44)
                            .background(Color.primary)
                            .cornerRadius(8)
                        
                        
                    }
                }
            }.alert(isPresented: $viewModel.showError, content: {
                Alert(title: Text(viewModel.erroString))
            })
        }
        
    }
       
}




struct PaymentSheetView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentSheetView(viewModel: PaymentSheetViewModel(job: dev.jobs[0], user: dev.user))
    }
}
