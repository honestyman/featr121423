//
//  UploadJobView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/10/23.
//

import SwiftUI
import PhotosUI

struct UploadJobView: View{
    @ObservedObject var viewModel: UploadJobViewModel
    @Binding var showingSelfAsPopup: Bool
    @EnvironmentObject var feedViewModel: FeedViewModel
    init(showingSelfAsPopup: Binding<Bool>) {
        _showingSelfAsPopup = showingSelfAsPopup
        viewModel = UploadJobViewModel()
    }
    var body: some View {
        ModifyJobView(viewModel: viewModel, showingSelfAsPopup: $showingSelfAsPopup)
            .onDisappear {
                viewModel.selectedImages = []
                feedViewModel.reload()
            }
    }
}

struct UploadJobView_Previews: PreviewProvider {
    static var previews: some View {
        UploadJobView(showingSelfAsPopup: .constant(false)).environmentObject(FeedViewModel())
    }
}
