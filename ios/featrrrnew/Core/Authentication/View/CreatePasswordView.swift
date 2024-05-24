//
//  CreatePasswordView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: CGFloat.md) {
            Text("Create a password")
                .font(Style.font.title2)
                .padding(.top)
            
            Text("Your password must be at least 6 characters in length.")
                .font(Style.font.caption)
                .foregroundColor(Color.lightBackground)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .lg)
            
            SecureField("Password", text: $viewModel.password)
                .modifier(TextFieldModifier())
                .padding(.top)
            
            NavigationLink {
                CompleteSignUpView()
            } label: {
                Text("Next")
                    .modifier(FeatchrButtonModifier())
            }
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            
            Spacer()
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension CreatePasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.password.isEmpty && viewModel.password.count > 5
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasswordView()
            .environmentObject(RegistrationViewModel())

    }
}
