//
//  CreateUserNameView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI

struct CreateUsernameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showCreatePasswordView = false

    var body: some View {
        VStack(spacing: CGFloat.md) {
            Text("Create username")
                .font(Style.font.title2)
                .padding(.top)
            
            Text("Make a username for your new account. You can always change it later.")
                .font(Style.font.caption2)
                .foregroundColor(Color.lightBackground)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .lg)
            
            ZStack(alignment: .trailing) {
                TextField("Username", text: $viewModel.username)
                    .modifier(TextFieldModifier())
                    .padding(.top)
                    .autocapitalization(.none)

                if viewModel.isLoading {
                    ProgressView()
                        .padding(.trailing, .xxlg)
                        .padding(.top, .md)
                }
            }
            
            Button {
                Task {
                    try await viewModel.validateUsername()
                }
            } label: {
                Text("Next")
                    .modifier(FeatchrButtonModifier())
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)

            Spacer()
        }
        .onReceive(viewModel.$usernameIsValid, perform: { usernameIsValid in
            if usernameIsValid {
                self.showCreatePasswordView.toggle()
            }
        })
        .navigationDestination(isPresented: $showCreatePasswordView, destination: {
            CreatePasswordView()
        })
        .onAppear {
            showCreatePasswordView = false
            viewModel.usernameIsValid = false
        }
    }
}

extension CreateUsernameView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.username.isEmpty
    }
}

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUsernameView()
            .environmentObject(RegistrationViewModel())
    }
}
