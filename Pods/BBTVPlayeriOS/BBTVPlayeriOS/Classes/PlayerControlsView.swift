////
////  PlayerControlsView.swift
////  BBTVPlayeriOS
////
////  Created by Banchai on 24/4/2563 BE.
////

#if canImport(SwiftUI)
import Foundation
import SwiftUI
import AVFoundation
import AVKit

// This is the SwiftUI view that contains the controls for the player
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct PlayerControlsView : View {
    @Binding private(set) var videoPos: Double
    @Binding private(set) var videoDuration: Double
    @Binding private(set) var seeking: Bool
    @Binding var controlAlpha: Double
    @Binding var isAutoHide: Bool
    @Binding var isPlaying: Bool
    
    let player: AVPlayer
    let dismiss: (() -> Void)?
    let hideControls: (() -> Void)
    
    @State private var playerPaused = true
    @GestureState private var isTap = false
    
    @State private var backwardName: String = "backward.fill"
    @State private var forwardName: String = "forward.fill"
    @State private var currentStateName: String = "play.fill"
    
    
    var body: some View {
        ZStack() {
            VStack {
                BBTVPlayeriOSSwiftUITopContainerView(dismiss: dismiss)
                
                Spacer()
                
                HStack(alignment: .center, spacing: 10) {
                    Text("\(Utility.formatSecondsToHMS(videoPos * videoDuration))")
                        .foregroundColor(.white)
                    
//                    Slider(value: $videoPos, in: 0...1, onEditingChanged: sliderEditingChanged(editingStarted:))
//                        .foregroundColor(.white)
//                        .accentColor(.white)
                    
                    Button(action: toggleSpeed) {
                        Text("x1.0")
                            .frame(width: 30, height: 30)
                            .padding(.top, 10.0)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10.0)
                            .foregroundColor(.black)
                    }.background(Color.yellow)
                }
                //                BBTVPlayeriOSSwiftUIBottomContainerView(videoPos: $videoPos, videoDuration: $videoDuration, dismiss: dismiss)
            }
            
            HStack {
                PlayerControlButtonView(imageName: $backwardName,
                                        size: CGSize(width: 48, height: 32),
                                        action: self.toggleBackForward)
                
                PlayerControlButtonView(imageName: $currentStateName,
                                        action: self.togglePlayPause)
                
                PlayerControlButtonView(imageName: $forwardName,
                                        size: CGSize(width: 48, height: 32),
                                        action: self.toggleForward)
            }
            //            BBTVPlayeriOSSwiftUICenterContainerView()
        }
            //
            //        VStack() {
            //
            //            BBTVPlayeriOSSwiftUITopContainerView(title: "TITLE", dismiss: dismiss)
            //
            //            BBTVPlayeriOSSwiftUICenterContainerView()
            //
            //            HStack {
            //                PlayerControlButtonView(imageName: $backwardName,
            //                                        size: CGSize(width: 48, height: 32),
            //                                        action: self.toggleBackForward)
            //
            //                PlayerControlButtonView(imageName: $currentStateName,
            //                                        action: self.togglePlayPause)
            //
            //                PlayerControlButtonView(imageName: $forwardName,
            //                                        size: CGSize(width: 48, height: 32),
            //                                        action: self.toggleForward)
            //            }
            //            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            //
            //            HStack(alignment: .center, spacing: 10) {
            //                Text("\(Utility.formatSecondsToHMS(videoPos * videoDuration))")
            //                    .foregroundColor(.white)
            //
            //                Slider(value: $videoPos, in: 0...1, onEditingChanged: sliderEditingChanged(editingStarted:))
            //                    .foregroundColor(.white)
            //                    .accentColor(.white)
            //
            //                Button(action: toggleSpeed) {
            //                    Text("x1.0")
            //                        .frame(width: 30, height: 30)
            //                        .padding(.top, 10.0)
            //                        .padding(.leading, 10)
            //                        .padding(.trailing, 10)
            //                        .padding(.bottom, 10.0)
            //                        .foregroundColor(.black)
            //                }.background(Color.yellow)
            //            }
            //            .padding(.top, 10.0)
            //            .padding(.leading, 10)
            //            .padding(.trailing, 10)
            //            .padding(.bottom, 10.0)
            //            .background(Color.clear)
            //        }
            .opacity(controlAlpha)
            .animation(.easeOut)
            .transition(.scale)
        
    }
    
    func toggleClose() {
        print("----+ close")
    }
    
    func toggleBackForward() {
        isAutoHide = false
        hideControls()
        print("----+ toggleBackForward")
    }
    
    func togglePlayPause() {
        isAutoHide = false
        isPlaying = !playerPaused
        
        pausePlayer(!playerPaused)
        
        guard !playerPaused else { return }
        hideControls()
        print("----+ togglePlayPause")
    }
    
    func toggleForward() {
        isAutoHide = false
        hideControls()
        print("----+ toggleForward")
    }
    
    func toggleSpeed() {
        print("----+ toggleSpeed")
    }
    
    private func pausePlayer(_ pause: Bool) {
        playerPaused = pause
        if playerPaused {
            player.pause()
        } else {
            player.play()
        }
        
        currentStateName = playerPaused ? "play.fill" : "pause.fill"
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        print("----+ sliderEditingChanged")
        if editingStarted {
            // Set a flag stating that we're seeking so the slider doesn't
            // get updated by the periodic time observer on the player
            seeking = true
            pausePlayer(true)
        }
        
        // Do the seek if we're finished
        if !editingStarted {
            let targetTime = CMTime(seconds: videoPos * videoDuration,
                                    preferredTimescale: 600)
            player.seek(to: targetTime) { _ in
                // Now the seek is finished, resume normal operation
                print("----+ sliderEditingChanged \(targetTime)")
                self.seeking = false
                
                let isPause = !self.isPlaying
                self.pausePlayer(!isPause)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.hideControls()
                }
            }
        }
    }
}

// MARK: - Top container

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUILabelView: View {
    @Binding private(set) var title: String?
    @State private(set) var color: Color?
    @State private(set) var font: Font?
    @State private(set) var fontWeight: Font.Weight?
    
    public var body: some View {
        Text(title ?? "Label")
            .fontWeight(fontWeight ?? .medium)
            .font(font ?? .body)
            .foregroundColor(color ?? .white)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUIBottonView: View {
    @State private(set) var iconName: String?
    @State private(set) var padding: CGFloat?
    
    var action: (() -> Void)
    
    public var body: some View {
        Button(action: action) {
            Image(systemName: iconName ?? "e.circle")
                .frame(width: 46, height: 46)
                .padding(.top, padding ?? .zero)
                .padding(.leading, padding ?? .zero)
                .padding(.trailing, padding ?? .zero)
                .padding(.bottom, padding ?? .zero)
                .foregroundColor(.white)
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BBTVPlayeriOSSwiftUIActionMenuView: View {
    public var body: some View {
        HStack() {
            //            BBTVPlayeriOSSwiftUIBottonView(iconName: "info.circle", action: { print("action 2") })
            BBTVPlayeriOSSwiftUIBottonView(iconName: "ellipsis", action: { print("action 1") })
                .rotationEffect(.degrees(90))
        }
    }
}

// MARK: - ETC

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct PlayerControlButtonView: View {
    @Binding private(set) var imageName: String
    
    var size: CGSize = CGSize(width: 32.0, height: 32.0)
    var action: (() -> Void)
    
    var body: some View {
        VStack{
            Button(action: action) {
                Image(systemName: imageName).resizable()
                    .frame(width: size.width, height: size.height)
                    .padding(.top, 10.0)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10.0)
                    .foregroundColor(.white)
            }.background(Color.white.opacity(0.3))
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 52, alignment: .center)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct PlayerControlBottomView: View {
    @Binding private var videoPos: Double
    @Binding private var videoDuration: Double
    
    private var onSliderEditingChanged: ((Bool) -> Void)
    private var onSpeedActionButton: (() -> Void)
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("\(Utility.formatSecondsToHMS(videoPos * videoDuration))")
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.3, x: 0, y: 2)
            
//            Slider(value: $videoPos, in: 0...1, onEditingChanged: sliderEditingChanged)
//                .foregroundColor(.white)
//                .accentColor(.white)
            
            Button(action: onSpeedActionButton) {
                Text("x1.0")
                    .frame(width: 30, height: 30)
                    .padding(.top, 10.0)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10.0)
                    .foregroundColor(.black)
            }.background(Color.yellow)
            
            // Show video duration
            //Text("\(Utility.formatSecondsToHMS(videoDuration))")
        }
        .padding(.top, 10.0)
        .padding(.leading, 10)
        .padding(.trailing, 10)
        .padding(.bottom, 10.0)
        .background(Color.clear)
    }
    
    private func sliderEditingChanged(editingStarted: Bool) {
        onSliderEditingChanged(editingStarted)
    }
}

#endif

