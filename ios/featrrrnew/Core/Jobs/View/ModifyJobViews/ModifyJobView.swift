//
//  UploadJobView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/10/23.
//

import SwiftUI
import PhotosUI



struct ModifyJobView<T: ModifyJobViewModel>: View {
    
    @State var imagePickerPresented = false
    @State var showingCustomerSheet = false
    @StateObject var viewModel: ModifyJobViewModel
    @Binding var showingSelfAsPopup: Bool
    
    @ViewBuilder
    private var imageSelector: some View {
        if viewModel.imageItems.count != 0 {
            ImageCarousel(carouselItems: $viewModel.imageItems, padding: EdgeInsets.init(top: 20, leading: 20, bottom: 20, trailing: 20))
        }
        
        
        Button {
            imagePickerPresented = true
        } label: {
            HStack {
                Spacer()
                if viewModel.imageItems.count == 0 {
                    Text("*Select Gallery Images")
                } else {
                    Text("Reselect Images")
                }
                Spacer()
            }
            .padding()
            .background(Color.field)
            .cornerRadius(.cornerS)
        }.padding(.bottom, 30)
    }
    
    private enum FocusedField {
            case category, bio, city, state, country, hourly, task, story
        }
    @FocusState private var focusedField: FocusedField?
    @ViewBuilder
    private var textFields: some View {
        Text("About you")
        VStack(alignment: .leading) {
            Text("*CATEGORY").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("What category are your services?", text: $viewModel.category, axis: .vertical)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .category)
            
            
            Text("*BIO").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("A short bio", text: $viewModel.jobBio, axis: .vertical)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .bio)
        }.padding(.bottom, 20)
        
        
        
        Text("Address")
        VStack(alignment: .leading) {
            Text("*CITY").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("City", text: $viewModel.city, axis: .vertical)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .city)
            
            
            Text("*STATE").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("State", text: $viewModel.state, axis: .vertical)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .state)
            
            Text("*COUNTRY").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("Country", text: $viewModel.country, axis: .vertical)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .country)
            
        }.padding(.bottom, 20)
        
        Text("Rate")
        
        VStack(alignment: .leading) {
            Text("*HOURLY RATE").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("$/Hour", text: $viewModel.hrString, axis: .vertical)
                .onlyNumeric($viewModel.hrString, numberStorage: $viewModel.hr)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .hourly)
                
                
            
            Text("*TASK RATE").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("$/Task", text: $viewModel.taskString, axis: .vertical)
                .onlyNumeric($viewModel.taskString, numberStorage: $viewModel.task)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .task)
            
            Text("*STORY POST RATE").font(Style.font.body2).foregroundStyle(Color.lightBackground)
            TextField("$/24-hours", text: $viewModel.storyPostString, axis: .vertical)
                .onlyNumeric($viewModel.storyPostString, numberStorage: $viewModel.storyPost)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
                .focused($focusedField, equals: .story)
        }
    }
    
    @ViewBuilder
    private var paymentButton: some View {
        VStack {
            Text("Payment")
            HStack {
                Text("*CARD").font(Style.font.body2).foregroundStyle(Color.lightBackground)
                Spacer()
                switch (viewModel.paymentState) {
                case .paymentLoading:
                    ProgressView()
                case .paymentError:
                    Chip(text: "Error", style: .cancel)
                case .noPaymentMethod:
                    Chip(text: "No Payment Method", style: .cancel)
                case .paymentOnFile:
                    Chip(text: "Payment On File", style: .success)
                }
            }
            
            Button {
                showingCustomerSheet = true
            } label: {
                HStack {
                    Spacer()
                    switch (viewModel.paymentState) {
                    case .paymentError, .noPaymentMethod, .paymentLoading:
                        Text("Add Payment")
                        
                    case .paymentOnFile:
                        if let last4 = viewModel.lastFourDigitsPayment {
                            Text("Change Payment (····\(last4))")
                        } else {
                            Text("Change Payment")
                        }
                        
                        
                    }
                    Spacer()
                }
                .padding()
                .background(Color.field)
                .cornerRadius(.cornerS)
            }
        }
    }
    
    @ViewBuilder
    private var customerSheetPopup: some View {
        if let sheet = viewModel.customerSheet {
            VStack{}.customerSheet(
                isPresented: $showingCustomerSheet,
                customerSheet: sheet,
                onCompletion: viewModel.onCompletion)
        }
    }
    
    @ViewBuilder
    private var loadingOverlay: some View {
        VStack{
            Spacer()
            ProgressView()
            Text("Uploading").frame(maxWidth: .infinity)
            Spacer()
        }.background(.ultraThinMaterial)
            
    }
    
    var body: some View {
        NavigationStack {
            
            
            ZStack {
                ScrollView {
                    
                    VStack() {
                        
                        imageSelector
                        textFields
                        
                    }
                    
                    paymentButton
                    
                }.padding(.horizontal, 30)
                    .scrollIndicators(.never)
                
                customerSheetPopup
                
                if viewModel.isUploading {
                    loadingOverlay
                }
            }.padding(.top)
                .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImages, maxSelectionCount: MAX_PHOTOS, selectionBehavior: .ordered, matching: .any(of: [.screenshots, .livePhotos, .images, .depthEffectPhotos]))
                .navigationTitle("Become a Featrrr")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showingSelfAsPopup.toggle()
                        } label: {
                            Text ("Cancel")
                        }
                    }
                    
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                Task {
                                    if (viewModel.submissionEnabled) {
                                        
                                        if let vM = viewModel as? UploadJobViewModel {
                                            var success = try await vM.uploadJob()
                                            if success {
                                                showingSelfAsPopup.toggle()
                                            }
                                        } else if let vM = viewModel as? EditJobViewModel {
                                            
                                            var success = try await vM.updateJob()
                                            if success {
                                                showingSelfAsPopup.toggle()
                                            }
                                        }
                                        
                                        
                                    } else {
                                        viewModel.sendErrorAlert()
                                    }
                                }
                            } label: {
                                if let vM = viewModel as? EditJobViewModel {
                                    Text ("Update")
                                } else {
                                    Text ("Upload")
                                }
                                
                            }.disabled(viewModel.isUploading)
                        }
                  
                }
                .onAppear {
                    viewModel.getDefaultPayment()
                }
                .alert("Validation Error", isPresented: $viewModel.showMessageError) {
                    Button("Dismiss") {
                        viewModel.showMessageError = false
                    }
                } message: {
                    HStack {
                        Text(viewModel.messageError)
                        Spacer()
                    }
                }
        }
    }
    
    
}
