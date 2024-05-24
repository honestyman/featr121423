//
//  Proposal.swift
//  featrrrnew
//
//  Created by Josh Beck on 3/22/24.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

// Written by ChatGPT 3.5
struct Proposal: Codable {
    
    
    let hourly: Bool?
    let hourlyStartDate: Date?
    let hourlyDuration: Double?
    let hourlyRate: Double?
    let task: Bool?
    let taskDate: Date?
    let taskRate: Double?
    let story: Bool?
    let storyDate: Date?
    let storyRate: Double?
    
   
    
    // Custom encoder
    enum CodingKeys: String, CodingKey {
        case hourly
        case hourlyStartDate
        case hourlyDuration
        case hourlyRate
        case task
        case taskDate
        case taskRate
        case story
        case storyDate
        case storyRate
    }

    init(
        hourly: Bool? = nil,
        hourlyStartDate: Date? = nil,
        hourlyDuration: Double? = nil,
        hourlyRate: Double? = nil,
        task: Bool? = nil,
        taskDate: Date? = nil,
        taskRate: Double? = nil,
        story: Bool? = nil,
        storyDate: Date? = nil,
        storyRate: Double? = nil) {
            self.hourly = hourly
            self.hourlyStartDate = hourlyStartDate
            self.hourlyDuration = hourlyDuration
            self.hourlyRate = hourlyRate
            self.task = task
            self.taskDate = taskDate
            self.taskRate = taskRate
            self.story = story
            self.storyDate = storyDate
            self.storyRate = storyRate
        }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(hourly, forKey: .hourly)
        try container.encode(hourlyStartDate, forKey: .hourlyStartDate)
        try container.encode(hourlyDuration, forKey: .hourlyDuration)
        try container.encode(hourlyRate, forKey: .hourlyRate)
        try container.encode(task, forKey: .task)
        try container.encode(taskDate, forKey: .taskDate)
        try container.encode(taskRate, forKey: .taskRate)
        try container.encode(story, forKey: .story)
        try container.encode(storyDate, forKey: .storyDate)
        try container.encode(storyRate, forKey: .storyRate)
        
    }

    // Custom decoder
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        hourly = try container.decodeIfPresent(Bool.self, forKey: .hourly)
        hourlyStartDate = try container.decodeIfPresent(Timestamp.self, forKey: .hourlyStartDate)?.dateValue()
        hourlyDuration = try container.decodeIfPresent(Double.self, forKey: .hourlyDuration)
        hourlyRate = try container.decodeIfPresent(Double.self, forKey: .hourlyRate)
        task = try container.decodeIfPresent(Bool.self, forKey: .task)
        taskDate = try container.decodeIfPresent(Timestamp.self, forKey: .taskDate)?.dateValue()
        taskRate = try container.decodeIfPresent(Double.self, forKey: .taskRate)
        story = try container.decodeIfPresent(Bool.self, forKey: .story)
        storyDate = try container.decodeIfPresent(Timestamp.self, forKey: .storyDate)?.dateValue()
        storyRate = try container.decodeIfPresent(Double.self, forKey: .storyRate)
        
    }
}

