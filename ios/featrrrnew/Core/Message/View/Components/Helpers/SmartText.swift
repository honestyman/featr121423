//
//  SmartText.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/25/24.
//

import SwiftUI

struct TextSegment: Identifiable, Hashable {
   
    
    let id = UUID()
    let text: String
    let isURL: Bool
    
    init(text: String, isURL: Bool) {
        self.text = text
        self.isURL = isURL
    }
}


class SmartViewModel: ObservableObject {
    @Published var showBottomSheet = false
    @Published var availableLinks: [URL] = []
}

struct SmartText: View {
    var text: String
    private var textSegments: [TextSegment] = []
    @StateObject private var viewModel: SmartViewModel
    @State private var linkUnreachable = false
    @State private var link: String = ""
    
    init(_ text: String) {
        
        // Initializers
        self.text = text
        self._viewModel = StateObject(wrappedValue: SmartViewModel())

        
        // Business logic
        self.textSegments = detectURLs(text: text)
       
    }
    var body: some View {
        VStack(spacing: 0) {
            
            textSegments.reduce(Text("")) { result, text in
                result + (text.isURL ? Text(text.text).underline() : Text(text.text))
            }
            
        }
        .onTapGesture(perform: {
            
            /// - NOTE: Workaround of sheet race condition bug - https://forums.developer.apple.com/forums/thread/745876
            let links = textSegments.compactMap { $0.isURL ? URL(string: $0.text) : nil }
            if links.count > 1 {
                viewModel.availableLinks = links
                viewModel.showBottomSheet = true
            } else if let onlyLink = links.first  {
                openUrl(onlyLink) { accepted in
                    if accepted == false {
                        link = onlyLink.absoluteString
                        linkUnreachable = true
                    }
                }
            } // Else: do nothing - it is just a text field
            
            
        })
        .padding()
        .sheet(isPresented: $viewModel.showBottomSheet) {
            LinkPopupView(availableLinks: $viewModel.availableLinks)
                .presentationDetents(
                    [.medium]
                )
        }
        .alert(isPresented: $linkUnreachable) {
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
    private func detectURLs(text: String) -> [TextSegment] {
        var segments: [TextSegment] = []
               let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
               let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
               var currentIndex = text.startIndex
               
               for match in matches {
                   if let range = Range(match.range, in: text) {
                       let link = text[range]
                       let beforeLink = text[currentIndex..<range.lowerBound]
                       segments.append(TextSegment(text: String(beforeLink), isURL: false))
                       segments.append(TextSegment(text: String(link), isURL: true))
                       currentIndex = range.upperBound
                   }
               }
               
               if currentIndex < text.endIndex {
                   let afterLastLink = text[currentIndex..<text.endIndex]
                   segments.append(TextSegment(text: String(afterLastLink), isURL: false))
               }
               
               return segments
    }
    private func openUrl(_ url: URL, completion: @escaping (Bool) -> ()) {
        
        var modifiedUrl: URL? = url
        if (!url.absoluteString.hasPrefix("https://") && !url.absoluteString.hasPrefix("http://")) {
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
}
