//
//  AudioMessageView.swift
//  featrrrnew
//
//  Created by Josh Beck on 2/28/24.
//

import SwiftUI


struct AudioMessagePreviewView: View {
    
    @ObservedObject var audioViewModel: AudioMessageSharedViewModel
    var body: some View {
        
        VStack {
            VStack( alignment: .leading ) {
                AudioMessageSharedView(backgroundColor: .primary, audioViewModel: audioViewModel)
            }
            .padding(.vertical, .sm)
            .padding(.horizontal)
            .frame(minHeight: 0, maxHeight: 50)
            .background(Color.primary.cornerRadius(.cornerS))
            .foregroundColor(Color.background)
        }
        
    }
}


struct AudioMessageView: View {
    
    var isFromCurrentUser: Bool
    var backgroundColor: Color
    @ObservedObject var audioViewModel: AudioMessageSharedViewModel
    var body: some View {
        
        VStack {
            VStack( alignment: .leading ) {
                AudioMessageSharedView(backgroundColor: backgroundColor, audioViewModel: audioViewModel)
            }
            .padding(.vertical, .md)
            .padding(.horizontal)
            .frame(minHeight: 0, maxHeight: 50)
            .background(ChatBubble(isFromCurrentUser: isFromCurrentUser).fill(backgroundColor))
            .foregroundColor(audioViewModel.foregroundColor)
            
        }
        
    }
}

fileprivate struct AudioMessageSharedView: View {
    var backgroundColor: Color
    @ObservedObject var audioViewModel: AudioMessageSharedViewModel
    var body: some View {

        LazyHStack(alignment: .center, spacing: CGFloat.sm) {
            
            if audioViewModel.soundSamples.isEmpty {
                
                Image(systemName: "waveform")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 14, height: 14)
                    .foregroundColor(audioViewModel.foregroundColor)
                ProgressView().tint(audioViewModel.foregroundColor)
                
            } else {
                
                Button {
                    audioViewModel.toggleAudio()
                } label: {
                    Image(systemName:  !(audioViewModel.isPlaying) ? "play.fill" : "pause.fill" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .foregroundColor(audioViewModel.foregroundColor)
                }
                
                
                
                HStack(alignment: .center, spacing: 2) {
                    ForEach(audioViewModel.soundSamples) { model in
                        BarView(value: self.audioViewModel.normalizeSoundLevel(level: model.magnitude), color: model.color)
                    }
                }
                Button {
                    audioViewModel.restartAudio()
                } label: {
                    Image(systemName:  "arrow.counterclockwise" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 14, height: 14)
                        .foregroundColor(audioViewModel.foregroundColor)
                }
            }
            
            if let duration = self.audioViewModel.duration {
                Text("\(duration) sec").font(Style.font.messageBody)
            }
        }
    }
    
}

#Preview {
    AudioMessageView(isFromCurrentUser: true, backgroundColor: Color.primary, audioViewModel: AudioMessageSharedViewModel(audioMessage: AudioMessage(path: URL(string: "https://www2.cs.uic.edu/~i101/SoundFiles/PinkPanther30.wav")!, duration: "1234.0"), foregroundColor: .foreground, sampleCount: 30))
}
