//
//  UploadJobViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/10/23.
//

//import Foundation
import PhotosUI
import SwiftUI
import Firebase
import StripePaymentSheet

@MainActor
class ModifyJobViewModel: ObservableObject {
    @Published private(set)var isUploading = false
    @Published var error: Error?
    @Published var selectedImages: [PhotosPickerItem] = [] {
        didSet {
            
                Task {
                    imageItems = await ImageCarouselItem.arrayWithItems(selectedImages)
                } //TODO: Will upload duplicates
            
        }
    }
    @Published var imageItems: [ImageCarouselItem] = [] {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var hr: Int?  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var hrString: String = ""
    @Published var task: Int?  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var taskString: String = ""
    @Published var storyPost: Int?  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var storyPostString: String = ""
    @Published var city = ""  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var state = ""  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var country = ""  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var category = ""  {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var jobBio = "" {
        didSet {
            updateSubmissionEnabled()
        }
    }
    @Published var submissionEnabled = false
    @Published var paymentState: PaymentState = .paymentLoading
    @Published var customerSheet: CustomerSheet?
    
    func setIsUploading(_ val: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isUploading = val
        }
    }
    init() {
        getCustomerSheet()
        updateSubmissionEnabled()
    }
    
    var messageError: String = ""
    @Published var showMessageError = false
    func sendErrorAlert() {
        messageError = ""

        if imageItems.isEmpty {
            messageError += "• Select 1+ Image(s)\n"
        }

        if !allFieldsIncluded() {
            messageError += "• Fill all fields\n"
        }

        if paymentState != .paymentOnFile {
            messageError += "• Provide a default payment method\n"
        }

        messageError += "\nPlease resolve these issues before proceeding"
        showMessageError = true
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
          case .error(_):
              paymentState = .paymentError
          }
      }
    private func allFieldsIncluded() -> Bool {
        return !jobBio.isEmpty && hr != nil && task != nil && storyPost != nil && !city.isEmpty && !state.isEmpty && !country.isEmpty && !category.isEmpty
    }
    func updateSubmissionEnabled() {
        let imagesIncluded = imageItems.count > 0
        let allFieldsIncluded = allFieldsIncluded()
        let paymentIncluded = paymentState == .paymentOnFile
        submissionEnabled = imagesIncluded && allFieldsIncluded && paymentIncluded
    }
    
    @Published var lastFourDigitsPayment: String?
    func getDefaultPayment() {
        if let user = AuthService.shared.user {
            PaymentService.standard.getDefaultPayment(user:user) {result in
                do {
                    let result = try result.get()
                    if result == nil {
                        self.paymentState = .noPaymentMethod
                    } else {
                        self.lastFourDigitsPayment = result?.last4
                        self.paymentState = .paymentOnFile
                    }
                } catch {
                    self.paymentState = .paymentError
                }
                
            }
        }
        
    }
    
    func clearData() {
        jobBio = ""
        hr = nil
        task = nil
        storyPost = nil
        category = ""
        city = ""
        state = ""
        country = ""
        selectedImages = []
    }
    
    
    func loadImages(withItems items: [PhotosPickerItem]) async {
        var imageI: [ImageCarouselItem] = []
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let image = UIImage(data: data) else { return }
            let imageCarouselItem = ImageCarouselItem(image: image)
            imageI.append(imageCarouselItem)
        }
        self.imageItems = imageI
        
    }
    

}
