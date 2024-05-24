//
//  LinkPopupView.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/25/24.
//

import SwiftUI

struct LinkPopupView: View {
    @Binding var availableLinks: [URL]
    @State var linkUnreachable: Bool = false
    @State var link: String = ""
    @Environment(\.dismiss) private var dismiss
    
    private func openUrl(_ url: URL, completion: @escaping (Bool) -> ()) {
        
        var modifiedUrl: URL? = url
        if url.absoluteString.hasPrefix("www") {
            modifiedUrl = URL(string: "https://" + url.absoluteString)
        }
        if let modifiedUrl = modifiedUrl, UIApplication.shared.canOpenURL(modifiedUrl) {
            UIApplication.shared.open(modifiedUrl, completionHandler: { success in
                completion(success)
            })
        } else {
            completion(false)
        }
    }
    
    var body: some View {
        NavigationView {
            
                List {
                    Section{
                        ForEach(availableLinks, id: \.self) { link in
                            Button {
                                openUrl(link) { success in
                                    if success == false {
                                        self.link = link.absoluteString
                                        linkUnreachable = true
                                    }
                                }
                            } label: {
                                Label(link.absoluteString, systemImage: "link")
                                        .underline(true)
                            }
                        }
                    } header: {
                        Text("Will open external browser")
                    }.foregroundColor(Color.background)
                }.navigationTitle("Select Link")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Dismiss") { // on tap gesture calls dismissal
                            dismiss()
                        }.foregroundColor(Color.secondary)
                    }
                })
            
        }.alert(isPresented: $linkUnreachable) {
            Alert(title: Text("Unable to Open Link"), primaryButton: .default(Text("Copy"), action: {
                
                UIPasteboard.general.string = link
                
                link = ""
                linkUnreachable = false
                
            }), secondaryButton: .default(Text("OK"), action: {
                
                link = ""
                linkUnreachable = false
                
            }))
        }
    }
}
