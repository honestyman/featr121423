//
//  SwiftUIView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/13/23.
//

import SwiftUI

struct TransactionAndCardView: View {
    @State private var sixteendigit = ""
    
    @State private var monthYear = ""
    
    @State private var cvv = ""
    
    
    @State private var zipcode = ""
    
    var body: some View {
        
        ScrollView {
            
            VStack{
//                Text("HI").font(/*.*/)
                // Title
                // Title 2
                // Title 3
                // Headline
                // Large Title
                // Callout
                // Caption - $123
                // Caption 2 - task
                // Footnote - Address
                // Subheadline
                // Body - Bio
                // Button - Checkout
                
                // Button - Small
                // Button - Large
                HStack{
                    Text("Balance: $1,238")
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                HStack {
                    Image(systemName: "creditcard")
                    
                    Text("...1234")
                    
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("edit")
                    }
                    
                }
                .padding()
                
                HStack {
                    
                    VStack{
                       
                        
                        HStack{
                            TextField("0000 0000 0000 0000", text: $sixteendigit)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color.field)
                                .cornerRadius(.cornerS)
                                .frame(width: 250)
                            
                            Spacer()
                        }
                        
                        VStack {
                            
                            HStack{
                                
                                TextField("MM/YY", text: $monthYear)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.field)
                                    .cornerRadius(.cornerS)
                                    .frame(width: 100)
                                
                                TextField("CVV", text: $cvv)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.field)
                                    .cornerRadius(.cornerS)
                                    .frame(width: 100)
                                
                                TextField("Zip", text: $zipcode)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .background(Color.field)
                                    .cornerRadius(.cornerS)
                                    .frame(width: 100)
                                
                                Spacer()
                            }
                            
                            
                            Button {
                                
                            } label: {
                                Text("Add Card")
                            }
                            .padding(.top)
                        }
                        
                    }
                    .padding()
                    
                    
                }
                
                
                Divider()
                    .padding(.horizontal)
                
                
                    Text("Transaction History")
                    .padding(.bottom, .lg)
                
                HStack {
                    VStack{
                        Text("July 13, 2023")
                            .font(Style.font.title4)
                        
                        Text("@toWhomWasPaid")
                        
                    }
                    
                    Spacer()
                    
                    Text("- $90")
                    
                }
                .padding()
                
                
                
                HStack {
                    VStack{
                        Text("July 13, 2023")
                            .fontWeight(.thin)
                            .font(Style.font.title4)
                        
                        Text("@fromWhoPaid")
                        
                    }
                    
                    Spacer()
                    
                    Text("+ $215")
                    
                }
                .padding()
                
                
            }
        }
    }
}

struct TransactionAndCardViewPreviews: PreviewProvider {
    static var previews: some View {
        TransactionAndCardView()
    }
}
