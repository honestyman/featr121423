//
//  EnterCardInfoView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/8/23.
//

import SwiftUI

struct EnterCardInfoView: View {
    
    @State private var cardNumber = ""
    
    @State private var expNumber = ""
    
    @State private var cvvNumber = ""
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            TextField("Enter 16 digit card number", text: $cardNumber)
                .autocapitalization(.none)
                .modifier(FeatrTextFieldModifier())
            
            HStack{
                TextField("09/28", text: $expNumber)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.field)
                    .cornerRadius(8)
                
                TextField("CVV", text: $cvvNumber)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.field)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
            
            NavigationLink {
                CompletedHireView()
            } label: {
                Text("Hire")
                    .font(Style.font.caption)
                    .foregroundColor(Color.background)
                    .frame(width: 360, height: 44)
                    .background(Color.success)
                    .cornerRadius(.cornerS)
            }
            .padding(.vertical)
        }
    }
}

struct EnterCardInfoView_Previews: PreviewProvider {
    static var previews: some View {
        EnterCardInfoView()
    }
}
