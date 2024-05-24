//
//  MKSearchView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/13/23.
//

/*import SwiftUI
import MapKit

struct MKSearchView: View {
    
    @State private var searchQuery = ""
    @State private var searchResults: [MKLocalSearchCompleter] = []
    
    private let completer = MKLocalSearchCompleter()
    
    init() {
        completer.resultTypes = .address
    }
    
    var body: some View {
        VStack {
            TextField("Enter a location", text: $searchQuery)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchQuery) { newValue in
                    completer.queryFragment = newValue
                }
            List(searchResults, id: \.self) {_ in
                Text(completion._)
            }
        }
        .onAppear {
            completer.delegate = self
        }
    }
}



struct MKSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MKSearchView()
    }
}

extension AutoCompleteTextField: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }
}*/
