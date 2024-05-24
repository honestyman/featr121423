//
//  AddEmailView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showCreateUsernameView = false

    var body: some View {
        VStack(spacing: CGFloat.md) {
            Text("Add your email")
                .font(Style.font.title4)
                .padding(.top)
            
            Text("You'll use this email to sign in to your account.")
                .font(Style.font.caption2)
                .foregroundColor(Color.lightBackground)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .lg)
            
            ZStack(alignment: .trailing) {
                TextField("Email", text: $viewModel.email)
                    .modifier(TextFieldModifier())
                    .padding(.top)
                    .autocapitalization(.none)
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.trailing, .xxlg)
                        .padding(.top, .md)
                }
                
                if viewModel.emailValidationFailed {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(Color.warning)
                        .padding(.trailing, .xxlg)
                        .padding(.top, .md)
                }
            }
            
            if viewModel.emailValidationFailed {
                Text("This email is already in use. Please login or try again.")
                    .font(Style.font.caption)
                    .foregroundColor(Color.warning)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, .xlg)
            }
                            
            Button {
                Task {
                    try await viewModel.validateEmail()
                }
            } label: {
                Text("Next")
                    .modifier(FeatchrButtonModifier())
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(viewModel.$emailIsValid, perform: { emailIsValid in
            if emailIsValid {
                self.showCreateUsernameView.toggle()
            }
        })
        .navigationDestination(isPresented: $showCreateUsernameView, destination: {
            CreateUsernameView()
        })
        .onAppear {
            showCreateUsernameView = false
            viewModel.emailIsValid = false
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

extension AddEmailView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && viewModel.email.contains(".")
    }
}

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddEmailView()
                .environmentObject(RegistrationViewModel())
        }
    }
}
