//
//  CarouselPreviewView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import SwiftUI


struct CarouselImagePreview: View {
    
    @Binding var previewImageUrls: [String]?
    @Binding var imageProfilePreview: Bool
    
    var body: some View {
        ZStack {
            if let previewImageUrls = previewImageUrls {
                Color.clear
                
                HStack {
                    Spacer()
                    Button {
                        self.previewImageUrls = nil
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                            .foregroundColor(Color(.background))
                    }
                }
                .padding(.lg)
                .zIndex(2)
                
                VStack {
                    
                    Spacer()
                    
                    if imageProfilePreview {
                        ImageCarousel(urls: previewImageUrls)
                            .threeFour()
                    } else {
                        ImageCarousel(urls: previewImageUrls)
                    }
                   
                    Spacer()
                }
                .zIndex(3)
                
                

            }
            
        }.background(Color.foreground.ignoresSafeArea().onTapGesture {
            self.previewImageUrls = nil
        })
    }
}
