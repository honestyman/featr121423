//
//  PaymentSheetViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/27/23.
//

import Foundation
import StripePaymentSheet
import StripePaymentsUI
import Firebase
import Combine

class PaymentSheetViewModel: ObservableObject {
    var job: JobPost
    let user: User
    
    private var cancellables = Set<AnyCancellable>()
    
    init(job: JobPost, user: User) {
        self.job = job
        self.user = user
    }
    
    @Published var paymentSheet: PaymentSheet?
    @Published var paymentResult: PaymentSheetResult?
    
    @Published var hourlyOn = false {
        didSet {
            calculateCost()
        }
    }
    @Published var taskOn = false {
        didSet {
            calculateCost()
        }
    }
    @Published var storyOn = false {
        didSet {
            calculateCost()
        }
    }
    
    @Published var currentTimeHr = Date() {
        didSet {
            calculateCost()
        }
    }
    @Published var endTimeHr = Date() {
        didSet {
            calculateCost()
        }
    }
    @Published var currentTimeTask = Date()
    @Published var currentTimeStoryPost = Date()
    
    @Published var isPaymentComplete: Bool = false //TODO: Remove?
    @Published var hasAskedForRefund: Bool = false
    
    @Published var erroString: String = ""
    @Published var showError: Bool = false
    
    @Published var isLoading: Bool = false
    
    @Published var formattedCost: String?
    private var totalCost: Double = 0.0
    private func calculateCost() {
        let hourlyRate: Double = Double(job.hr)
        totalCost = max(5, getTimeDifference(job: job, start: currentTimeHr, end: endTimeHr, rate: hourlyRate, isToggledTask: taskOn, isToggledStoryPost: storyOn, isToggledHr: hourlyOn))
        formattedCost = String(format: "%.2f", totalCost)
    }
    
    func sendJobProposal() async {
        do {
            
            //Run again to make sure most updated values are pulled in
            calculateCost()
            
            let hourly = hourlyOn
            let hourlyStartDate: Date? = hourlyOn ? currentTimeHr : nil
            let hourlyDuration: Double? = hourlyOn ? timeDifference(start: currentTimeHr, end: endTimeHr) : nil
            let hourlyRate: Double? = hourlyOn ? Double(job.hr) : nil
            let task = taskOn
            let taskDate: Date? = taskOn ? currentTimeTask : nil
            let taskRate: Double? = taskOn ? Double(job.task) : nil
            let story = storyOn
            let storyDate: Date? = storyOn ? currentTimeStoryPost : nil
            let storyRate: Double? = storyOn ? Double(job.storyPost) : nil
            
            let bid = Proposal(hourly: hourly, hourlyStartDate: hourlyStartDate, hourlyDuration: hourlyDuration, hourlyRate: hourlyRate, task: task, taskDate: taskDate, taskRate: taskRate, story: story, storyDate: storyDate, storyRate: storyRate)
            
            if let documentID = try JobProposalService.standard.sendJobProposal(forJob: job, withJob: bid).get() {
                
                if let chatUser = job.user {
                    let service = ChatService(chatPartner: chatUser)
                    try await service.sendMessage(type: .proposal(documentID))
                    
                }
            } else {
                erroString = "No Proposal ID was captured"
                showError = true
            }
            Log.i("Successfully posted job bid")
        } catch {
            erroString = error.localizedDescription
            showError = true
            Log.d("When trying to get the job bid \(error.localizedDescription)")
        }
    }
 
    
    func onPaymentCompletion(result: PaymentSheetResult) {
        self.paymentResult = result
        self.isPaymentComplete=true
    }
    private func timeDifference(start: Date, end: Date) -> Double {
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: start)
       
        let endComponents = calendar.dateComponents([.hour, .minute], from: end)
        
        let startHours = Double(startComponents.hour ?? 0)
        let startMinutes = Double(startComponents.minute ?? 0)
        let endHour = Double(endComponents.hour ?? 0)
        let endMinute = Double(endComponents.minute ?? 0)
        let totalHours = endHour - startHours + ((endMinute - startMinutes) / 60)
        
        return totalHours
    }
    func getTimeDifference(job: JobPost, start: Date, end: Date, rate: Double, isToggledTask: Bool, isToggledStoryPost: Bool, isToggledHr: Bool) -> Double {
       
     
        let totalHours = timeDifference(start: start, end: end)
        var totalCost = totalHours * rate
        
        if !isToggledHr {
            totalCost -= totalCost
        }
       
        if isToggledTask {
            totalCost += Double(job.task)
        }
        
        if isToggledStoryPost {
            totalCost += Double(job.storyPost)
        }
        
        return totalCost
    }
    
}
