//
//  PersonalInfoView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/13/23.
//

import SwiftUI

struct PersonalInfoView: View {
    
    @State private var email = ""
    @State private var fullName = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var dob = ""
    @State private var password = ""
    @State private var username = ""
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    
                    VStack{
                        Text("Full Name")
                            .font(Style.font.title4)
                        
                        TextField("Jordan Marono", text: $fullName)
                    }
                    .padding()
                    
                    VStack {
                        Text("Username")
                            .fontWeight(.thin)
                            .font(Style.font.title4)
                     
                        TextField("", text: $username)
                    }
                    .padding()
                    
                   
                        VStack{
                                VStack{
                                    Text("Email")
                                        .font(Style.font.title4)
                                    
                                    TextField("JordanM@gmail.com", text: $email)
                                }
                                .padding()
                                
                                VStack {
                                    Text("Address")
                                        .font(Style.font.title4)
                                    TextField("48 Bridge St", text: $address)
                                }
                                .padding()
                                
                                VStack {
                                    Text("City")
                                        .font(Style.font.title4)
                                    TextField("Houston", text: $city)
                                }
                                .padding()
                                
                                VStack {
                                    Text("State")
                                        .font(Style.font.title4)
                                    
                                    TextField("Texas", text: $state)
                                }
                                .padding()
                                
                                VStack {
                                    Text("DOB")
                                        .font(Style.font.title4)
                                    
                                    TextField("08 / 26 / 2004", text: $dob)
                                        .keyboardType(.numberPad)
                                }
                                .padding()
                            
                            VStack {
                                Text("Password")
                                    .font(Style.font.title4)
                                
                                TextField("", text: $password)
                            }
                        }
                    
                    Button {
                        
                    } label: {
                        Text("Edit")
                    }
                }
                
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView()
    }
}
