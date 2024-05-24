//
//  AudioRecordingService.swift
//  featrrrnew
//
//  Created by Josh Beck on 2/28/24.
//

import Foundation
import AVFoundation
import SwiftUI

class AudioViewModel: NSObject, ObservableObject {
    let minimumSoundThreshhold: Float = 2
    
    /// Helper normalization method
    public func normalizeSoundLevel(level: Float?) -> CGFloat {
        if let level = level {
            let level = max(minimumSoundThreshhold*2, (level + 70)) / 2 // between 2
            return CGFloat(level)
        } else {
            return CGFloat(minimumSoundThreshhold)
        }
    }
    
}
