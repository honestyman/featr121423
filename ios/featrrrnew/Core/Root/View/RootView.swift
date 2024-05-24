//
//  ContentView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/27/23.
//

import SwiftUI

struct RootView: View {
    
    @StateObject var viewModel = RootViewModel()
    //@StateObject var registrationViewModel = RegistrationViewModel()
    @State var selectedIndex = 0
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                LoginView()
                    .environmentObject(RegistrationViewModel())
            } else {
                if let user = viewModel.currentUser {
                    MainTabView(user: user, selectedIndex: $selectedIndex)
                }
            /*else if let currentUser = viewModel.currentUser {
                MainTabView(user: user, selectedIndex: $selectedIndex)*/
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
