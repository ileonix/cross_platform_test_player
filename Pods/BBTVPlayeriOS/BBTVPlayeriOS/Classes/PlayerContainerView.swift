////
////  PlayerContainerView.swift
////  BBTVPlayeriOS
////
////  Created by Banchai on 24/4/2563 BE.
////

#if canImport(SwiftUI)
import Foundation
import SwiftUI
import AVFoundation
import AVKit

// This is the SwiftUI view which contains the player and its controls
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct PlayerContainerView: View {
    // The progress through the video, as a percentage (from 0 to 1)
    @State private var videoPos: Double = 0
    // The duration of the video in seconds
    @State private var videoDuration: Double = 0
    // Whether we're currently interacting with the seek bar or doing a seek
    @State private var seeking = false
    @State private var alpha: Double = 1
    @State private var isAutoHide: Bool = true
    @State private var isPlaying: Bool = false
    //    @State private var isShowing: Bool = false
    @State var workItem: DispatchWorkItem?
    private let player: AVPlayer
    private let dismiss: (() -> Void)?
    
    init(url: URL, onDismiss: (() -> Void)? = nil) {
        player = AVPlayer(url: url)
        dismiss = onDismiss
    }
    
    var body: some View {
        ZStack {
            // preview thumbnail
            PlayerView(videoPos: $videoPos, videoDuration: $videoDuration, seeking: $seeking, player: player)
            PlayerControlsView(videoPos: $videoPos,
                               videoDuration: $videoDuration,
                               seeking: $seeking,
                               controlAlpha: $alpha,
                               isAutoHide: $isAutoHide,
                               isPlaying: $isPlaying,
                               player: player,
                               dismiss: onDismiss,
                               hideControls: hideControls)
        }
            
//        .gesture(
//            TapGesture().onEnded({ (_) in
//                if self.alpha == 1 {
//                    print("---- isHiding")
//                    self.hideControls()
//                } else {
//                    print("---- isShowing")
//                    self.isAutoHide = true
//                    self.showControls()
//                }
//            })
//        )
    }
    
    func onDismiss() {
        player.pause()
        guard dismiss != nil else { return }
        dismiss!()
    }
    
    func showControls() {
        //        self.isShowing = true
        workItem?.cancel()
        workItem = DispatchWorkItem {
            UIView.animate(withDuration: 0.45, animations: {
                self.alpha = 1
            }) { (bool) in
                print("----+ showControls finish")
                self.autoHideControls()
            }
        }
        if let _workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: _workItem)
        }
    }
    
    func hideControls() {
        //        self.isShowing = false
        workItem?.cancel()
        workItem = DispatchWorkItem {
            print("----+ hideControls \(self.isAutoHide)")
            UIView.animate(withDuration: 0.45) {
                self.isAutoHide = false
                self.alpha = 0
            }
        }
        if let _workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: _workItem)
        }
    }
    
    func autoHideControls() {
        workItem = DispatchWorkItem {
            print("----+ auto hideControls \(self.isAutoHide)")
            guard self.isAutoHide, !self.isPlaying else { return }
            print("----+ auto")
            self.hideControls()
        }
        if let _workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: _workItem)
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct PlayerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerContainerView(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
    }
}

#endif
