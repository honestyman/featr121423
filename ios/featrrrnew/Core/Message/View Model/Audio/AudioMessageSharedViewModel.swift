//
//  ChatsViewModel.swift
//  featrrrnew
//
//  Created by Buddie Booking on 8/10/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import PhotosUI
import SwiftUI
import AVKit

/// This view model handles displaying / managing the waveforms for the audio message player
class AudioMessageSharedViewModel: AudioViewModel, AVAudioPlayerDelegate {
    
    @Published var isPlaying: Bool = false
    @Published var audioError: Bool = false
    @Published public var soundSamples = [AudioPreviewModel]()
    
    @Published var session: AVAudioSession!
    
    let foregroundColor: Color
    let url: URL
    
    var player: AVAudioPlayer?
    
    // Properties responsible for visualizing audio
    var dataManager: AudioServiceProtocol
    var duration: String?
    private let audioSampleCount: Int
    private var timer: Timer?
    private var index = 0
    private var isComplete = false
    
    // Holds the various file URLs that must be deallocated on audio deletion
    private var localURLs: [URL] = []
    
    
    init(audioMessage: AudioMessage, foregroundColor: Color, sampleCount: Int, dataManager: AudioServiceProtocol = AudioService.shared) {
        self.url = audioMessage.path
        self.audioSampleCount = sampleCount
        self.dataManager = dataManager
        self.foregroundColor = foregroundColor
        self.duration = audioMessage.duration
        
        super.init()
        
        self.loadAudio()
        
        // Initialize the audio session
        do {
            session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord)
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            
        } catch {
            Log.d("An audio session initializer error thrown: \(error.localizedDescription)")
        }
        
        // Run loading the audio on the background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            // Capture the URL of the "saved" audio
            if var currentURL = self?.url {
                do {
                    if currentURL.absoluteString.hasPrefix("https://") {
                        let data = try Data(contentsOf: currentURL)
                        let directory = FileManager.default.temporaryDirectory
                        let fileName = "\(UUID().uuidString).m4a"
                        currentURL = directory.appendingPathComponent(fileName)
                        try data.write(to: currentURL)
                        
                        // Save the written local URLs to an array for deletion later
                        self?.localURLs.append(currentURL)
                    }
                    
                } catch {
                    Log.d("An audio file error was thrown: \(error.localizedDescription)")
                }
                
                
                do {
                    self?.player = try AVAudioPlayer(contentsOf: currentURL)
                    self?.player?.delegate = self
                } catch {
                    Log.d("Audio Player error thrown: \(error.localizedDescription)")
                    self?.player = nil
                    
                    // Set published variables on the main thread
                    DispatchQueue.main.async {
                        self?.audioError = true
                    }
                    
                }
            }
            
        }
    }
    
    deinit {
        // Purge local temporary files from the system
        for localURL in localURLs {
            do {
                try FileManager.default.removeItem(at: localURL)
            } catch {
                Log.d("There was an error removing the files from the file manager: \(error.localizedDescription)")
            }
        }
    }
    
    func loadAudio() {
        visualizeAudio()
    }
    
    func startTimer() {
        
        countDuration { duration in
            let time_interval = duration / Double(self.audioSampleCount)
            
            self.timer = Timer.scheduledTimer(withTimeInterval: time_interval, repeats: true, block: { (timer) in
                if self.index < self.soundSamples.count {
                    withAnimation(Animation.linear) {
                        self.soundSamples[self.index].color = self.foregroundColor
                    }
                    self.index += 1
                }
            })
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.pause()
        timer?.invalidate()
        isPlaying = false
        isComplete = true
    }
    

    
    // Toggle audio play / pause
    func toggleAudio() {
        
        if isPlaying {
            pauseAudio()
        } else {
            if isComplete {
                restartAudio()
                isComplete = false
            }
            
            if let player = player {
                player.play()
            }
            
            isPlaying.toggle()
            startTimer()
            countDuration { _ in }
        }
    }
    
    func restartAudio() {
        player?.pause()
        player?.currentTime = 0
        index = 0
        if isPlaying {
            player?.play()
        }
        
        
        self.soundSamples = self.soundSamples.map { tmp -> AudioPreviewModel in
            var cur = tmp
            cur.color = foregroundColor.opacity(0.5)
            return cur
        }
    }
    func pauseAudio() {
        player?.pause()
        timer?.invalidate()
        self.isPlaying = false
    }
    
    
    func countDuration(completion: @escaping(Float64) -> ()) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let player = self?.player {
                
                DispatchQueue.main.async {
                    completion(player.duration)
                }
                return
            }
            
            
            DispatchQueue.main.async {
                completion(1)
            }
        }
        
    }
    
    // Display the waveform for the audio
    private func visualizeAudio() {
        dataManager.buffer(url: url, samplesCount: audioSampleCount, color: foregroundColor.opacity(0.5)) { results in
            self.soundSamples = results
        }
    }
    
    // Remove the audio notifcation
    func removeAudio() {
        do {
            try FileManager.default.removeItem(at: url)
            NotificationCenter.default.post(name: NSNotification.Name("hide_audio_preview"), object: nil)
        } catch {
            Log.d("When removing audio an error was thrown: \(error.localizedDescription)")
        }
    }
    
}
