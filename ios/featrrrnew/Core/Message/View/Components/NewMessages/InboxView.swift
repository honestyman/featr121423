//
//  InboxView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/9/23.
//

import SwiftUI

struct InboxView: View {
    
    //let user: User
    @StateObject var viewModel = InboxViewModel()
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        
        NavigationStack{
            
                List {
                    ForEach(viewModel.recentMessages) { message in
                        ZStack {
                            NavigationLink(value: message) {
                                EmptyView()
                            }.opacity(0.0)
                            
                            InboxRowView(message: message)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                
            
            .navigationDestination(for: Message.self, destination: { message in
                if let user = message.user {
                    ChatsView(user: user)
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        CircularProfileImageView(user: user)
                        
                        Text("Featrrr Messages")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.purple)
                    }
                }
            }
        }
    }
}

struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
    }
}
