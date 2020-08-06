//
//  BBTVPlayeriOSRewindView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 22/4/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSRewindView: UIView {
    var delegateSlider: BBTVPlayeriOSSliderDelegate?
    let rewindConstInSecond = 10.0
    var kvoRateContext = 0
    var imageView: UIImageView?
    private var DurationLabel: UILabel = UILabel()
    public var progress: Double?
    public var player: AVPlayer? {
        didSet {
            if let duration = player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if durationSeconds >= 0 {
                    self.isHidden = false
                } else {
                    self.isHidden = true
                }
            }
        }
    }
    public var configure : BBTVPlayeriOSConfigure?
    var container: UIViewController?
    
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        self.configure = configure
        self.container = container
        updatePosition()
        setUpUI()
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView = UIImageView()
        if let _imageView = imageView {
            _imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(_imageView)
            _imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            _imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            _imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            _imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
    
    func hideControlUI() {
        guard let _control = superview else { return }
        if self.isPlaying == true {
            self.configure?.updateControlUIwork?.cancel()
            self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                UIView.animate(withDuration: 0.45, animations: {
                    _control.alpha = 0
                })
            })
            if let updateControlUIwork = self.configure?.updateControlUIwork {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: updateControlUIwork)
            }
        }
    }
    
    public func setUpUI() {
        imageView?.image = self.loadImageBundle(named: "RewindButton")
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let duration = CMTimeGetSeconds(player?.currentTime() ?? CMTime(seconds: 0.0, preferredTimescale: 600))
        let targetTimeInSecond = duration - rewindConstInSecond
        let minDurationInSecond = CMTimeGetSeconds(CMTime(seconds: 0.0, preferredTimescale: 600))
        if targetTimeInSecond < minDurationInSecond {
            self.seek(to: minDurationInSecond)
        } else {
            self.seek(to: targetTimeInSecond)
        }
    }
    
    func seek(to time: TimeInterval) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        delegateSlider?.setDurationProgress(second: cmTime.seconds)
        player?.seek(to: cmTime, completionHandler: { (success) in
            if success {
            }
        })
    }
}
