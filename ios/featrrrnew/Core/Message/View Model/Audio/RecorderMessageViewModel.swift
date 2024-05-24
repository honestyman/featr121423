//
//  AudioRecordingService.swift
//  featrrrnew
//
//  Created by Josh Beck on 2/28/24.
//

import Foundation
import AVFoundation
import SwiftUI

/// The model responsible for visualizing / controlling recording audio
class RecorderMessageViewModel: AudioViewModel, AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        
    }
    /// The published file URL that the record view model is writting to
    public var fileURL: URL
    
    /// Is the view currently recording
    @Published var isRecording: Bool = false
    
    /// What is the duration string
    @Published public var duration: String = "0.0"
    
    /// Whether there was an audio error
    @Published public var audioPermissionsError: Bool = false
    
    /// An array displaying the sound samples information
    @Published public var soundSamples = [AudioPreviewModel]()

    /// The string description regarding whether the audio has reached it's max duration
    @Published public var audioLengthMessage: String?
    
    // Properties storing audio visualization / recording properties
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer? = nil
    private var currentSample: Int
    private let numberOfSamples: Int
 
    init(numberOfSamples: Int) {
        
        if numberOfSamples <= 0 {
            fatalError("The numberOfSamples property must be greater than 0 ")
        }
        
        self.numberOfSamples = numberOfSamples
        
        // Initialize a temporary audio file at the local directory
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("audio_file")
        
        // Capture the audio file for consumption by other methods
        fileURL = url
        
        self.currentSample = 0
        
        super.init()
        
        for i in 0..<numberOfSamples {
            self.soundSamples.append(AudioPreviewModel(magnitude: nil, color: Color.foreground, id: i))
        }
        
        // Initialize the AVAudioSession
        let audioSession = AVAudioSession.sharedInstance()
        
        
        // Set the recorder settings
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        // Attempt to initialize the audio recorder
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            audioRecorder?.delegate = self
            
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
        } catch {
            audioPermissionsError = true
            audioRecorder = nil
            Log.d(error.localizedDescription)
        }
        
        // After all the permissions are initialized, request to access the audio permissions
        requestAudioPermission(audioSession: audioSession)
    }
    
    // Request the audio permissions
    private func requestAudioPermission(audioSession: AVAudioSession) {
        
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { [weak self] (isGranted)  in
                if !isGranted {
                    self?.audioPermissionsError = true
                    /// Note - Send a notification to the parent model to work around the Alert subview bug
                    NotificationCenter.default.post(name: NSNotification.AudioPermissions, object: nil)
                } else {
                    // Run display logic on the main thread
                    DispatchQueue.main.sync { [weak self] in
                        self?.startRecording()
                    }
                    
                }
            }
        } else {
            // The audio permission is captured so start recording
            self.startRecording()
        }
    }
    
   
    func startRecording() {
        if isRecording == false {
            startTimer()
        }
        isRecording = true
    }
    func pauseRecording() {
        isRecording = false
        audioRecorder?.pause()
        timer?.invalidate()
    }
    
    // Visualize the audio waveforms rythmically using a timer
    private func startTimer() {
        
        let audioVisualizationRefreshRate: Double = 0.01
        
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.record()
        
        timer?.invalidate() //In case a thread conflict causes multiple instances of Timer
        
        timer = Timer.scheduledTimer(withTimeInterval: audioVisualizationRefreshRate, repeats: true, block: { [weak self] (timer)  in
            
            guard let self = self else { return }
            
            self.updateDurationString() //Once the recording is stopped, the audio current time goes back to 0 – update before it is called
            if audioRecorder?.currentTime ?? 0 > MAX_AUDIO_DURATION - DURATION_WARNING_OFFSET {
                self.updateAudioLengthMessage()
            }
            if audioRecorder?.currentTime ?? 0 >= MAX_AUDIO_DURATION {
                audioLengthMessage = "Max Audio Length"
                finishRecording()
                
            }
            self.audioRecorder?.updateMeters()
            self.soundSamples[self.numberOfSamples - self.currentSample - 1].magnitude = self.audioRecorder?.averagePower(forChannel: 0) ?? self.minimumSoundThreshhold
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            
        })
        
        // Run the timer on the common loop to ensure it runs even on Scroll or when the timer mode is switched
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    // Set the duration string
    private func updateDurationString(){
        
        /// Note - We don't accept a parameter but directly refernece the audioRecorder because in low memory situations there might be conflicting instances of updateDurationString called for different "times" as the Timer may be delayed; we consider the audioRecorder the ultimate source of truth
        
        self.duration = String(format: "%.1f", self.audioRecorder?.currentTime ?? "0.0")
    }
    
    // Set the audio length message duration string
    private func updateAudioLengthMessage(){
        
        /// Note - We don't accept a parameter but directly refernece the audioRecorder because in low memory situations there might be conflicting instances of updateDurationString called for different "times" as the Timer may be delayed; we consider the audioRecorder the ultimate source of truth
        if let currentTime = self.audioRecorder?.currentTime {
            self.audioLengthMessage = "\(String(format: "%.1f", MAX_AUDIO_DURATION - currentTime)) Sec Remaining"
        }
    }
    
    // Cancel the recording
    func cancelRecording() {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            Log.d("Cancelling the recording threw: \(error.localizedDescription)")
        }
        finishRecording()
    }
    private func finishRecording() {
        timer?.invalidate()
        audioRecorder?.stop()
        isRecording = false
    }
    
    // Gracefully complete the recording process
    func completeRecording(toMessage: Binding<AudioMessage?> ){
        toMessage.wrappedValue = AudioMessage(path: fileURL, duration: duration)
        finishRecording()
    }
 
    // Deinitialize the recording
    deinit {
        finishRecording()
    }
    
}
