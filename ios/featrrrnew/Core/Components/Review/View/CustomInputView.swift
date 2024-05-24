//
//  CustomInputView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/26/23.
//

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    let placeholder: String
    
    var action: () -> Void
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color.background)
                .frame(width: UIScreen.main.bounds.width, height: 0.75)
                .padding(.bottom, .sm)
            
            HStack {
                TextField(placeholder, text: $inputText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Style.font.body)
                    .frame(minHeight: 30)
                
                Button(action: action) {
                    Text("Send")
                        .bold()
                        .foregroundColor(Color.background)
                }
            }
            .padding(.bottom, .sm)
            .padding(.horizontal)
        }
    }
}
