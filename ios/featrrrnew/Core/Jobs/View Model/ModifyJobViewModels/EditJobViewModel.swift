//
//  UploadJobViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 7/10/23.
//

//import Foundation
import PhotosUI
import SwiftUI
import Firebase
import StripePaymentSheet
class EditJobViewModel: ModifyJobViewModel {
    
    var job: JobPost
    /// If this is being consumed in order to edit a job, pass the job to be editted
    init(editableJob: JobPost) {
        job = editableJob
        super.init()
        fillFieldsFromJob()
    }
    
    func fillFieldsFromJob() {
        
        jobBio = job.jobBio
        hrString = "\(job.hr)"
        hr = job.hr
        taskString = "\(job.task)"
        task = job.task
        storyPostString = "\(job.storyPost)"
        storyPost = job.storyPost
        category = job.category
        city = job.city
        state = job.state
        country = job.country
        
        for url in job.imageUrls {
            imageItems.append(ImageCarouselItem(url: url))
        }
    }
    func updateJob() async throws -> Bool {
        guard let docId = job.id else {
            return false
        }
        
        setIsUploading(true)
        
        var fields: [AnyHashable: Any] = [:]
        
        if(jobBio != job.jobBio) {
            fields["jobBio"] = jobBio
        }
        if(hr != job.hr) {
            fields["hr"] = hr
        }
        if(task != job.task) {
            fields["task"] = task
        }
        if(storyPost != job.storyPost) {
            fields["storyPost"] = storyPost
        }
        if(category != job.category) {
            fields["category"] = category
        }
        if(city != job.city) {
            fields["city"] = city
        }
        if(state != job.state) {
            fields["state"] = state
        }
        if(country != job.country) {
            fields["country"] = country
        }
        
        
        let imageUrls = try await ImageUploadService.standard.uploadImages(imageItems: imageItems)
        
        guard let safeImageUrls = imageUrls else {
            
            Log.c("Image URLs were not set; probably an API issue.  Terminating early")
            setIsUploading(false)
            return false
        }
        fields["imageUrls"] = safeImageUrls
        
        guard !fields.isEmpty else {
            Log.d("Nothing to update")
            setIsUploading(false)
            return false
        }
        
        do {
            let doc = COLLECTION_JOBS.document(docId)
            try await doc.updateData(fields)
            let updatedJob = try await doc.getDocument().data(as: JobPost.self)
            job = updatedJob
            setIsUploading(false)
            return true
        } catch {
            Log.d(error.localizedDescription)
            setIsUploading(false)
            self.error = error
            return false
        }
    }
}
