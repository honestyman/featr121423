//
//  MessageViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/25/23.
//

import Firebase

struct MessageViewModel {
    let message: Message
    
    var currentUid: String { return Auth.auth().currentUser?.uid ?? "" }
    
    var isFromCurrentUser: Bool { return message.fromId == currentUid }
}
