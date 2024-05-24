//
//  CompleteSignUpVIew.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel

    var body: some View {
        VStack(spacing: CGFloat.md) {
            Spacer()

            Text("Welcome to \(String.appName), \(viewModel.username)")
                .font(Style.font.title2)
                .padding(.top)
                .multilineTextAlignment(.center)
            
            Text("Click below to complete registration and start using Instagram.")
                .font(Style.font.caption)
                .multilineTextAlignment(.center)
                .padding(.horizontal, .lg)
            
            Button {
                Task { try await viewModel.createUser() }
            } label: {
                Text("Complete Sign Up")
                    .modifier(FeatchrButtonModifier())
            }
            
            Spacer()
        }
    }
}

struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSignUpView()
            .environmentObject(RegistrationViewModel())
    }
}
