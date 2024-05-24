//
//  ImagePreviewView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import SwiftUI
import Kingfisher

struct ImagePreviewView: View {
    
    @Binding var previewImageUrl: String?
    
    var body: some View {
        ZStack {
            if let previewImageUrl = previewImageUrl {
                Color.clear
                
                HStack {
                    Spacer()
                    Button {
                        self.previewImageUrl = nil
                    } label: {
                            Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(Color(.background))
                    }
                }
                .zIndex(2)
                
                VStack {
                   
                    Spacer()
                    KFImage(URL(string: previewImageUrl))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20)
                        .clipShape(RoundedRectangle(cornerRadius: .cornerM))
                        .padding(.sm)
                    Spacer()
                    
                }.zIndex(3)
               

            }
            
        }.background(Color.foreground.ignoresSafeArea().onTapGesture {
            self.previewImageUrl = nil
        })
    }
}
