////
////  PlayerUIView.swift
////  BBTVPlayeriOS
////
////  Created by Banchai on 24/4/2563 BE.
////

#if canImport(SwiftUI)
import AVFoundation
import AVKit
import Foundation
import SwiftUI

// This is the UIView that contains the AVPlayerLayer for rendering the video
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
class PlayerUIView: UIView {
    private let player: AVPlayer
    private let playerLayer = AVPlayerLayer()
    private let videoPos: Binding<Double>
    private let videoDuration: Binding<Double>
    private let seeking: Binding<Bool>
    private var durationObservation: NSKeyValueObservation?
    private var timeObservation: Any?
    
    init(player: AVPlayer, videoPos: Binding<Double>, videoDuration: Binding<Double>, seeking: Binding<Bool>) {
        self.player = player
        self.videoDuration = videoDuration
        self.videoPos = videoPos
        self.seeking = seeking
        
        super.init(frame: .zero)
        
        backgroundColor = .black
        playerLayer.player = player
        playerLayer.addSublayer(playerLayer)
        
        // Observe the duration of the player's item so we can display it
        // and use it for updating the seek bar's position
        durationObservation = player.currentItem?.observe(\.duration, changeHandler: { [weak self] drmItem, change in
            guard let self = self else { return }
            self.videoDuration.wrappedValue = drmItem.duration.seconds
        })
        
        // Observe the player's time periodically so we can update the seek bar's
        // position as we progress through playback
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // If we're not seeking currently (don't want to override the slider
            // position if the user is interacting)
            guard !self.seeking.wrappedValue else {
                return
            }
            
            // update videoPos with the new video time (as a percentage)
            self.videoPos.wrappedValue = time.seconds / self.videoDuration.wrappedValue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerLayer.frame = bounds
    }
    
    func cleanUp() {
        // Remove observers we setup in init
        durationObservation?.invalidate()
        durationObservation = nil
        
        if let observation = timeObservation {
            player.removeTimeObserver(observation)
            timeObservation = nil
        }
    }
}

#endif
