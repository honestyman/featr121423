//
//  MessageInputView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 11/26/23.
//

import Foundation
import PhotosUI
import SwiftUI

struct BarView: View {
    let value: CGFloat
    var color: Color = Color.white
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .cornerRadius(3)
                .frame(width: 3, height: value)
        }
    }
}

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

    // Layout
    var body: some View {
        ZStack(alignment: .trailing) {
           
            VStack {
                HStack {

                        messageInput
                        
                    if !viewModel.isRecording {
                       sendButton
                        
                        if viewModel.audioMessage == nil {
                            recordButton
                        }
                        
                    }
                }
            }
        }
        .padding(.horizontal)
        .overlay {
            if viewModel.messageImage != nil || viewModel.audioMessage != nil {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            }
        }
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
                print("DEBUG: [Message Input View] There was a call to display an alert but no error was flagged")
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
                    .padding(.bottom, 8)
            } else {
                textFieldInput
            }
        }.environmentObject(viewModel)
    }
    
    
    @ViewBuilder
    var textFieldInput: some View {
            if let image = viewModel.messageImage {
                ZStack(alignment: .topTrailing) {
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 80, height: 140)
                        .cornerRadius(10)
                    
                    Button(action: {
                        viewModel.messageImage = nil
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .padding(8)
                    })
                    .background(Color(.gray))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                }
                .padding(8)
                
                Spacer()
            } else if let audioFile = viewModel.audioMessage {
                ZStack(alignment: .trailing) {
                    
                    AudioMessagePreviewView(audioViewModel: AudioMessageSharedViewModel(audioMessage: audioFile, foregroundColor: .white, sampleCount: audioPreviewSamples))

                    
                    Button(action: {
                        viewModel.audioMessage = nil
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .padding(8)
                    })
                    .background(Color(.gray))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding(8)
                }
                .padding(8)
                
                Spacer()
            } else {
                HStack {
                    if messageText.isEmpty {
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            Image(systemName: "photo")
                                .padding(.horizontal, 4)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    TextField("Message...", text: $messageText, axis: .vertical)
                        .padding(12)
                        .padding(.leading, 4)
                        .padding(.trailing, 48)
                        .background(Color.theme.secondaryBackground)
                        .clipShape(Capsule())
                        .font(.subheadline)
                        .frame(minHeight: 50)
                    
                }
                .padding(.bottom, 8)
                
            }
    }
    

    // Buttons
    var recordButton: some View {
        Button(action: {
            viewModel.isRecording = !viewModel.isRecording
        }, label: {
            Image(systemName: "waveform")
                .foregroundColor(.gray)
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

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(messageText: .constant(""),
                         viewModel: ChatsViewModel(user: dev.user))
    }
}
