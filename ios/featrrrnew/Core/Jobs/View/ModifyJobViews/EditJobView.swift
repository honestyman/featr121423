//
//  UploadJobView.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/10/23.
//

import SwiftUI
import PhotosUI




struct EditJobView: View{
    @ObservedObject var viewModel: EditJobViewModel
    @EnvironmentObject var jobViewModel: JobListViewModel
    @Binding var showingSelfAsPopup: Bool
    init(job: JobPost, showingSelfAsPopup: Binding<Bool>) {
        viewModel = EditJobViewModel(editableJob: job)
        _showingSelfAsPopup = showingSelfAsPopup
    }
    var body: some View {
        ModifyJobView(viewModel: viewModel, showingSelfAsPopup: $showingSelfAsPopup)
            .onDisappear {
                viewModel.selectedImages = []
                jobViewModel.reload()
            }
    }
}

struct EditJobView_Previews: PreviewProvider {
    static var previews: some View {
        EditJobView(job: dev.jobs[3], showingSelfAsPopup: .constant(true)).environmentObject(JobListViewModel(user: dev.users[1]))
    }
}
