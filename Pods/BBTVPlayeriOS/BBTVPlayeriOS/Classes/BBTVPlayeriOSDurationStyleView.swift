//
//  BBTVPlayeriOSDurationView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 19/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public protocol BBTVPlayeriOSDurationDelegate {
    func setDurationProgress(second: Double)
}

public class BBTVPlayeriOSDurationStyleView: UIView {
    private weak var container: UIViewController?
    public var configure : BBTVPlayeriOSConfigure?
    public var durationLabel: UIButton = UIButton()
    public var progress: Double?
    public var player: AVPlayer? {
        didSet {
            if let isSeeking = configure?.isSeeking, !isSeeking {
                if let duration = player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    if var seconds = progress {
                        let progress = Float(seconds / durationSeconds)
                        if seconds > durationSeconds {
                            seconds = durationSeconds
                        }
                        
                        let sDurationSeconds = Utility.formatSecondsToHMS(durationSeconds)
                        var sSecounds = Utility.formatSecondsToHMS(seconds)
                        if sDurationSeconds.count >= 8 {
                            sSecounds = Utility.formatSecondsToHMS(seconds, eStyle: .long)
                        }
                        if sDurationSeconds != "LIVE" {
                            self.durationLabel.setTitle("\(sSecounds) / \(sDurationSeconds)", for: .normal)
                            self.durationLabel.backgroundColor = .clear
                            self.durationLabel.clipsToBounds = true
                            self.durationLabel.layer.cornerRadius = 4.0
                            self.durationLabel.layer.masksToBounds = true
                        } 
                    }
                }
            }
        }
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?){
        self.container = container
        self.configure = configure
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        
        updatePosition()
        setUpUI()
    }
    
    public func setUpUI(){
    }
    
    func updatePosition(){
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        var guide: AnyObject = superview
        if #available(iOS 11.0, *) {
            guide = superview.safeAreaLayoutGuide
        }
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            durationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            durationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            durationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

extension BBTVPlayeriOSDurationStyleView: BBTVPlayeriOSDurationDelegate {
    public func setDurationProgress(second: Double) {
        if let duration = player?.currentItem?.duration {
            let durationSeconds = CMTimeGetSeconds(duration)
            var seconds = second
            let progress = Float(seconds / durationSeconds)
            if seconds > durationSeconds {
                seconds = durationSeconds
            }
            
            let sDurationSeconds = Utility.formatSecondsToHMS(durationSeconds)
            var sSecounds = Utility.formatSecondsToHMS(seconds)
            if sDurationSeconds.count >= 8 {
                sSecounds = Utility.formatSecondsToHMS(seconds, eStyle: .long)
            }
            
            if sDurationSeconds != "LIVE" {
                self.durationLabel.setTitle("\(sSecounds) / \(sDurationSeconds)", for: .normal)
                self.durationLabel.backgroundColor = .clear
                self.durationLabel.clipsToBounds = true
                self.durationLabel.layer.cornerRadius = 4.0
                self.durationLabel.layer.masksToBounds = true
            }
        }
    }
}

