//
//  AppDelegate.swift
//  CustomControls
//
//  Copyright © 2019 Brightcove, Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set the AVAudioSession category to allow audio playback in the background
        // or when the mute button is on. Refer to the AVAudioSession Class Reference:
        // https://developer.apple.com/documentation/avfoundation/avaudiosession
        
        do {
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        }
        
        return true
    }
}

