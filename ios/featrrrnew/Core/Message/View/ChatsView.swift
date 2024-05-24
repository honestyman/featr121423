//
//  ChatsView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/9/23.
//

import SwiftUI

struct ChatsView: View {
    @State private var messageText = ""
    @State private var isInitialLoad = false
    @StateObject var viewModel: ChatsViewModel
    let user: User
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatsViewModel(user: user))
    }
    
    
   
   
    var body: some View {
        
        VStack {
            
            ReversedLazyMessageScrollView(messages: $viewModel.messages, user: user)
            Spacer()
            MessageInputView(messageText: $messageText, viewModel: viewModel)
        }
        .onDisappear {
            viewModel.removeChatListener()
        }
        .onChange(of: viewModel.messages, perform: { _ in
            Task { try await viewModel.updateMessageStatusIfNecessary()}
        })
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView(user: dev.user)
    }
}

