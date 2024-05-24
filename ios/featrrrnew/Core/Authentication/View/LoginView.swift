//
//  LoginView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isGuest: Bool = false
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    
    /*func continueAsGuest(){
        isGuest = true
    }*/
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                
                Image("featrlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 200)
                
                VStack(spacing: CGFloat.md) {
                    TextField("Enter your email", text: $email)
                        .background(Color.field)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Password", text: $password)
                        .background(Color.field)
                        .modifier(TextFieldModifier())
                    
                    Button(action: {
                        Task { try await viewModel.login(withEmail: email, password: password) }
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Log In")
                                .font(Style.font.caption)
                                .foregroundColor(Color.background)
                                .padding()
                            Spacer()
                        }
                        .background(formIsValid ? Color.primary : Color.lightBackground)
                        
                        
                    })
                    .disabled(!formIsValid)
                    
                    HStack {
                        
                        
                        NavigationLink(
                            destination: ResetPasswordView(email: $email),
                            label: {
                                Text("Forgot Password?")
                                    .font(Style.font.caption)
                            })
                        Spacer()
                    }.padding(.bottom, .xxlg)
                    
                }
                
                
             
               
                
                
                Button {
                    Log.c("Unable to sign in a user anonymously")
                    /*Task {
                     try await  viewModel.signInAnonymous()
                     }*/
                } label: {
                    Text("Continue as guest")
                        .font(Style.font.caption)
                        .foregroundColor(.success)
                        .underline()
                }
                .padding(.top)
                
                VStack(spacing: CGFloat.lg) {
                    HStack {
                        Rectangle()
                            .frame(width:( UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                            .foregroundColor(Color(.background))
                        
                        Text("OR")
                            .font(Style.font.caption2)
                            .foregroundColor(Color.lightBackground)
                        
                        Rectangle()
                            .frame(width:( UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                            .foregroundColor(Color.background)
                    }
                    
                    HStack {
                        Image("featrlogo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Button {
                            
                        } label: {
                            Text("Continue with Facebook")
                                .font(Style.font.caption)
                                .foregroundColor(Color.facebook)
                        }
                        
                    }
                }
                .padding(.top, .xxsm)
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    AddEmailView()
                        .environmentObject(registrationViewModel)
                } label: {
                    HStack(spacing: CGFloat.xxsm) {
                        Text("Don't have an account?")
                            .font(Style.font.caption)
                        
                        Text("Sign Up")
                            .font(Style.font.caption)
                    }
                }
            }
        }
        .padding(.horizontal, .lg)
        .padding(.vertical, .md)
        
    }
}


extension LoginView: AuthenticationFormProtocol {
   
    var formIsValid: Bool {
        
        return !email.isEmpty
        && email.contains("@")
        && email.contains(".")
        && !password.isEmpty
        && password.count > 5 
            
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(RegistrationViewModel())
    }
}
