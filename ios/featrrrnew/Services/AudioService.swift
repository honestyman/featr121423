//
//  AudioService.swift
//  featrrrnew
//
//  Created by Josh Beck on 2/28/24.
//

import Foundation
import Combine
import AVFoundation
import SwiftUI

protocol AudioServiceProtocol{
    func buffer(url: URL, samplesCount: Int, color: Color?, completion: @escaping([AudioPreviewModel]) -> ())
}

struct AudioService: AudioServiceProtocol {
    public static let shared: AudioServiceProtocol = AudioService()

    func buffer(url: URL, samplesCount: Int, color: Color?, completion: @escaping ([AudioPreviewModel]) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                
                var current_url = url
                if url.absoluteString.hasPrefix("https://") {
                    let data = try Data(contentsOf: url)
                    let directory = FileManager.default.temporaryDirectory
                    let fileName = "\(UUID().uuidString).m4a"
                    current_url = directory.appendingPathComponent(fileName)
                    try data.write(to: current_url)
                }
                
                let file = try AVAudioFile(forReading: current_url)
                if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                              sampleRate: file.fileFormat.sampleRate,
                                              channels: file.fileFormat.channelCount, interleaved: false),
                   let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) {
                    
                    try file.read(into: buf)
                    guard let floatChannelData = buf.floatChannelData else { return }
                    let frameLength = Int(buf.frameLength)
                    
                    let samples = Array(UnsafeBufferPointer(start:floatChannelData[0], count:frameLength))
                    
                    var result = [AudioPreviewModel]()
                    
                    let chunked = samples.chunked(into: samples.count / samplesCount)
                    for row in chunked {
                        var accumulator: Float = 0
                        let newRow = row.map{ $0 * $0 }
                        accumulator = newRow.reduce(0, +)
                        let power: Float = accumulator / Float(row.count)
                        let decibles = 10 * log10f(power)
                        
                        result.append(AudioPreviewModel(magnitude: decibles, color: color ?? Color.lightBackground))
                        
                    }
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            } catch {
                Log.d(error.localizedDescription)
            }
        }
    }
}
