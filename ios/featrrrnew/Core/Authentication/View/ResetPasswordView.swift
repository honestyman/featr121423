//
//  ResetPasswordView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var mode
    @Binding private var email: String
    
    init(email: Binding<String>) {
        self._email = email
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.primary, Color.secondary]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image("instagram_logo_white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 100)
                    .foregroundColor(.background)
                                    
                VStack(spacing: CGFloat.lg) {
                    CustomTextField(text: $email, placeholder: "Email")
                        .padding()
                        .background(Color.field)
                        .cornerRadius(.cornerS)
                        .foregroundColor(.background)
                        .padding(.horizontal, .xlg)
                }
                                    
                Button(action: {
                    viewModel.resetPassword(withEmail: email)
                    
                }, label: {
                    Text("Send Reset Password Link")
                        .font(Style.font.title2)
                        .foregroundColor(.background)
                        .frame(width: 360, height: 50)
                        .background(Color.primary)
                        .clipShape(Capsule())
                        .padding()
                })
                
                Spacer()
                
                Button(action: { mode.wrappedValue.dismiss() }, label: {
                    HStack {
                        Text("Already have an account?")
                            .font(Style.font.caption)
                        
                        Text("Sign In")
                            .font(Style.font.caption)
                    }.foregroundColor(.background)
                })
            }
            .padding(.top, -.xxlg)
        }
        .onReceive(viewModel.$didSendResetPasswordLink, perform: { _ in
            self.mode.wrappedValue.dismiss()
        })
    }
}
