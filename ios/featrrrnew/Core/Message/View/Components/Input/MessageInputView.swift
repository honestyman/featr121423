//
//  MessageInputView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 11/26/23.
//

import Foundation
import PhotosUI
import SwiftUI


struct MessageInputView: View {
    @Binding var messageText: String
    @ObservedObject var viewModel: ChatsViewModel
    @State var audioPermissionError: Bool = false

    private let recordSamples = 25
    private let audioPreviewSamples = 30
    
    init(messageText: Binding<String>, viewModel: ChatsViewModel) {
        self._messageText = messageText
        self.viewModel = viewModel
    }

    var imagesPreview: some View {
        ScrollView(.horizontal) {
            HStack(spacing: CGFloat.sm) {
                ForEach(viewModel.imageItems) { item in
                    ZStack(alignment: .topTrailing) {
                        if let image = item.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                                .frame(width: 80, height: 140)
                                .cornerRadius(.cornerS)
                            
                            Button(action: {
                                viewModel.removeImage(item: item)
                            }, label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                                    .padding(.sm)
                            })
                            .background(Color.lightBackground)
                            .foregroundColor(.background)
                            .clipShape(Circle())
                        }
                    }
                    .padding(.vertical, .sm)
                }
                
            }
            .padding(.horizontal, .sm)
        }.clipShape(RoundedRectangle(cornerRadius: .cornerS))
            .overlay {
                if !viewModel.imageItems.isEmpty {
                    RoundedRectangle(cornerRadius: .cornerS)
                        .stroke(Color.lightBackground, lineWidth: 1)
                }
            }
    }
    // Layout
    var body: some View {
        ZStack(alignment: .trailing) {
           
            VStack {
                HStack {
                    if viewModel.imageItems.count > 0 {
                        imagesPreview
                        sendButton
                        
                    } else {
                        messageInput
                            .overlay {
                                if viewModel.messageImage != nil || viewModel.audioMessage != nil {
                                    RoundedRectangle(cornerRadius: .cornerS)
                                        .stroke(Color.lightBackground, lineWidth: 1)
                                }
                            }
                            .padding(.vertical)
                        
                        if !viewModel.isRecording {
                            sendButton
                            
                            if viewModel.audioMessage == nil {
                                recordButton
                            }
                            
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.AudioPermissions)) { output in
            viewModel.showAlert = true
            audioPermissionError = true
            viewModel.isRecording = false
        }
        .alert(isPresented: $viewModel.showAlert) {
            if viewModel.sendableError {
                return Alert(title: Text("Unable to Send"), message: Text("There was an issue when attempting to send your message.  Try again later"), dismissButton: .default(Text("OK")) {
                    viewModel.sendableError = false
                    viewModel.showAlert = false
                })
            } else if audioPermissionError {
                return Alert(title: Text("Audio Recording Disabled"), message: Text("To record audio, go to Settings > \(String.appName) and enable 'Microphone' access"), dismissButton: .default(Text("OK")) {
                    audioPermissionError = true
                    viewModel.showAlert = false
                })
            } else {
                Log.d("There was a call to display an alert but no error was flagged")
                return Alert(title: Text("Info"), message: Text("Your request was unable to be completed. Please contact support for further assistance"), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    // Input fields
    @ViewBuilder
    var messageInput: some View {
        HStack {
            if viewModel.isRecording {
                RecorderMessageView(recordViewModel: RecorderMessageViewModel(numberOfSamples: recordSamples))
                    .padding(.bottom, .sm)
            } else {
                textFieldInput
            }
        }.environmentObject(viewModel)
    }
    
    
    @ViewBuilder
    var textFieldInput: some View {
           if let audioFile = viewModel.audioMessage {
                ZStack(alignment: .trailing) {
                    
                    AudioMessagePreviewView(audioViewModel: AudioMessageSharedViewModel(audioMessage: audioFile, foregroundColor: .foreground, sampleCount: audioPreviewSamples))

                    
                    Button(action: {
                        viewModel.audioMessage = nil
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .padding(.sm)
                    })
                    .background(Color.lightBackground)
                    .foregroundColor(.background)
                    .clipShape(Circle())
                    .padding(.sm)
                }
                .padding(.sm)
                
                Spacer()
            } else {
                HStack {
                    if messageText.isEmpty {
                        PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: MAX_PHOTOS, selectionBehavior: .ordered, matching: .any(of: [.screenshots, .livePhotos, .images, .depthEffectPhotos])) {
                            Image(systemName: "photo")
                                .padding(.horizontal, .xxsm)
                                .foregroundColor(Color.lightBackground)
                        }
                    }
                    
                    TextField("Message...", text: $messageText, axis: .vertical)
                        .padding(.sm)
                        .padding(.leading, .xxsm)
                        .padding(.trailing, .xxlg)
                        .background(Color.secondaryBackground)
                        .clipShape(Capsule())
                        .font(Style.font.messageBody)
                        .frame(minHeight: 50)
                    
                }
                .padding(.bottom, .sm)
                
            }
    }
    

    // Buttons
    var recordButton: some View {
        Button(action: {
            viewModel.isRecording = !viewModel.isRecording
        }, label: {
            Image(systemName: "waveform")
                .foregroundColor(Color.lightBackground)
        })
    }
    
    
    
    var sendButton: some View {
        Button {
            Task {
                
                await viewModel.sendMessage(messageText)
                if !viewModel.sendableError {
                    messageText = ""
                }
                
            }
        } label: {
            Text("Send")
                .fontWeight(.semibold)
        }
        .padding(.horizontal)
    }
  
}
