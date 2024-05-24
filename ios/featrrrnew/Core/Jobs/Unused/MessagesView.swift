//
//  MessagesView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 6/29/23.
//
//
//import SwiftUI
//
//struct MessagesView: View {
//    var body: some View {
//        NavigationStack{
//            VStack{
//                HStack(spacing: 16){
//                    Image(systemName: "person.fill")
//                        .font(.system(size: 34, weight: .heavy))
//                        .padding(8)
//                        .overlay(RoundedRectangle(cornerRadius: 44)
//                            .stroke(Color(
//                                .label), lineWidth: 1))
//                    
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("USERNAME")
//                            .font(.system(size: 24, weight: .bold))
//                            
//                    }
//                    Spacer()
//                }
//                .padding()
//                ScrollView {
//                    ForEach(0..<10, id: \.self) {num in
//                        VStack {
//                            NavigationLink {
//                                Text("Destination")
//                            } label: {
//                                HStack(spacing: 16) {
//                                    Image(systemName: "person.fill")
//                                        .font(.system(size: 32))
//                                        .foregroundColor(.black)
//                                    VStack(alignment: .leading) {
//                                        Text("Username")
//                                            .font(.system(size: 16, weight: .bold))
//                                            .foregroundColor(.black)
//                                        Text("Message sent to user")
//                                            .font(.system(size: 14))
//                                            .foregroundColor(Color(.lightGray))
//                                    }
//                                    Spacer()
//                                    
//                                    Text("22d")
//                                        .font(.system(size: 14, weight: .semibold))
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                            
//                            Divider()
//                                .padding(.vertical, 8)
//                        }
//                        .padding(.horizontal)
//                        
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//}
//
//struct MessagesView_Previews: PreviewProvider {
//    static var previews: some View {
//        MessagesView()
//    }
//}
