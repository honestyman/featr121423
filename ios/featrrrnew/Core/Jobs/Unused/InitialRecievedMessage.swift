//
//  ChatLogView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//
//
//import SwiftUI
//
//struct InitialRecievedMessage: View {
//    
//    @State var chatText = ""
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                
//                ForEach(0..<10) {num in
//                    HStack {
//                        Spacer()
//                        HStack {
//                            Text("Fake Message")
//                                .foregroundColor(.white)
//                        }
//                        .padding()
//                        .background(Color.purple)
//                        .cornerRadius(8)
//                    }
//                    .padding(.horizontal)
//                    .padding(.top, 8)
//                }
//                
//                HStack{ Spacer() }
//            }
//            .background(Color(.init(white: 0.95, alpha: 1)))
//            
//            HStack{
//            Button {
//            } label: //HStack(spacing: 16){
//                {
//                    Image(systemName: "photo")
//                }
//            TextEditor(text: $chatText)
//                .frame(height: 70)
//                .border(Color.black)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//            
//            //.fixedSize(horizontal: (4 != 4), vertical: (4 != 3))
//            //TextField("Description", text: $chatText)
//            Button {
//                
//            } label: {
//                Text("Send")
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 8)
//            .background(Color.purple)
//            .cornerRadius(8)
//        }
//        .padding(.horizontal)
//        .padding(.vertical, 8)
//        
//        HStack {
//            Button {
//                
//            } label: {
//                Text("Decline offer")
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 8)
//            .background(Color.red)
//            .cornerRadius(8)
//            
//            Button {
//                
//            } label: {
//                Text("Accept offer")
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 10)
//            .padding(.vertical, 8)
//            .background(Color.green)
//            .cornerRadius(8)
//        }
//        
//        
//        
//    }
//        .navigationTitle("ChatLog")
//        .navigationBarTitleDisplayMode(.inline)
//
//        
//    }
//}
//
//struct InitialRecievedMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            InitialRecievedMessage()
//        }
//    }
//}
