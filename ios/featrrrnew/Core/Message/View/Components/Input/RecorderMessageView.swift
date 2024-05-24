//
//  AudioRecorderView.swift
//  featrrrnew
//
//  Created by Josh Beck on 2/28/24.
//

import SwiftUI

struct RecorderMessageView: View {
    
    @ObservedObject var recordViewModel: RecorderMessageViewModel
    @EnvironmentObject var mainViewModel: ChatsViewModel
    
    var body: some View {
        
        ZStack {
            if !recordViewModel.audioPermissionsError {
                VStack(alignment: .center, spacing: 0)  {
                    if let msg = recordViewModel.audioLengthMessage {
                            Text(msg)
                            .font(Style.font.messageCaption)
                                .foregroundColor(.background)
                                .padding(.top, .xxsm)
                                
                    }
                    HStack(spacing: CGFloat.sm) {
                        
                        Image(systemName: "waveform.badge.mic")
                            .foregroundColor(.background)
                            .opacity(0.5)
                        
                        Button(action: {
                            self.recordViewModel.cancelRecording()
                            mainViewModel.isRecording = false
                        }, label: {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.background)
                            
                        })
                        Spacer()
                        HStack(spacing: 2) {
                            
                            // Visualize the audio
                            ForEach(recordViewModel.soundSamples) { level in
                                BarView(value: self.recordViewModel.normalizeSoundLevel(level: level.magnitude))
                            }
                            
                        }
                        
                        // Display the duration
                        Text("\(recordViewModel.duration) sec")
                            .font(Style.font.messageBody)
                            .minimumScaleFactor(0.5)
                            .foregroundColor(.background)
                            .frame(width: 50) //We set the width so subtle changes in the glyphs won't move the content
                        
                        Spacer()
                        
                        if self.recordViewModel.isRecording {
                            
                            Button(action: {
                                self.recordViewModel.pauseRecording()
                            }, label: {
                                Image(systemName: "stop.fill")
                                    .foregroundColor(.background)
                            })
                            
                        } else {
                            Button(action: { 
                                self.recordViewModel.completeRecording(toMessage: $mainViewModel.audioMessage)
                                mainViewModel.isRecording = false
                            }, label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.background)
                            })
                        }
                    }.frame(maxHeight: 50)
                    
                }
                .padding(.vertical, .xxsm)
                .padding(.horizontal)
                .background(Color.primary.cornerRadius(.cornerL))
                
            }
        }
    }
}

struct AudioRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        RecorderMessageView(recordViewModel: RecorderMessageViewModel(numberOfSamples: 20))
    }
}
