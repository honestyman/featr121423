//
//  CurrentUserProfileView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//

import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @StateObject var viewModel: ProfileViewModel
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false
    @State private var bottomSheet = false
    @State var bottomSheetContent: SettingsView? = nil
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .topTrailing) {
                    
                    VStack {
                        MinifiedProfileHeaderView(viewModel: viewModel)
                            
                        Divider()
                        if viewModel.user.isCurrentUser {
                            JobListView(user: user)
                        }
                    }
                    
                    Button {
                        selectedSettingsOption = nil
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .tint(Color.background)
                    }
                    .padding(.trailing, .lg)
                    .padding(.top, .xxxlg)
                }
            }
            .navigationDestination(isPresented: $showDetail, destination: {
                Text(selectedSettingsOption?.title ?? "")
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()){
                        Image(systemName: "gear")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onChange(of: selectedSettingsOption) { newValue in
                guard let option = newValue else { return }
                
                if option != .logout {
                    self.showDetail.toggle()
                } else {
                    AuthService.shared.signout()
                }
            }
        }
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView(user: dev.user)
    }
}
