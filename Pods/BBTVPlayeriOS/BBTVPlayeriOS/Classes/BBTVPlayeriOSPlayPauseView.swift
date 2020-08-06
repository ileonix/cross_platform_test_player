//
//  BBTVPlayeriOSPlayPauseView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 22/4/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public protocol BBTVPlayeriOSPlayPauseDelegate {
    func setUpdateUI()
}

public class BBTVPlayeriOSPlayPauseView: UIView {
    var kvoRateContext = 0
    var container: UIViewController?
    public var player: AVPlayer?
    public var configure : BBTVPlayeriOSConfigure?
    var imageView: UIImageView?
    
    var isAutoPlay: Bool {
        return self.configure?.isAutoPlay ?? false
    }
    
    var isPlaying: Bool {
        // return (player?.rate != 0 && player?.error == nil) && isAutoPlay
        return (self.configure?.isPlaying ?? false) && isAutoPlay
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        self.configure = configure
        self.container = container
        updatePosition()
        updateUI()
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        updateStatus()
        updateUI()
    }
    
    private func updateStatus() {
        if (configure?.isShowControl ?? false) {
            if self.configure?.isPlaying ?? false {
                self.configure?.isPlaying = false
                player?.pause()
                showControlUI()
            } else {
                self.configure?.isPlaying = true
                self.player?.rate = self.configure?.speedRate ?? 1.0
                self.hideControlUI()
            }
        }
    }
    
    public func updateUI() {
        if self.configure?.isPlaying ?? false {
            
            imageView?.image = self.loadImageBundle(named: "Pause Button")
            
        } else {
            imageView?.image = self.loadImageBundle(named: "Play Button")
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
    
    func showControlUI() {
        guard let _control = superview, (configure?.isShowControl ?? false) else { return }
        print("showControlUI: play/pause")
        self.configure?.updateControlUIwork?.cancel()
        self.configure?.updateControlUIwork = DispatchWorkItem(block: {
            UIView.animate(withDuration: 0.25, animations: {
                _control.alpha = 1
            }) { (bool) in
                print("แสดง play/pause")
                self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                    if self.isPlaying == true {
                        self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                            print("แสดง-> ออก")
                            UIView.animate(withDuration: 0.45, animations: {
                                _control.alpha = 0
                            })
                        })
                        if let updateControlUIwork = self.configure?.updateControlUIwork {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: updateControlUIwork)
                        }
                    } else {
                        print("แสดง-> ไม่ออก")
                    }
                })
                if let updateControlUIwork = self.configure?.updateControlUIwork {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: updateControlUIwork)
                }
            }
        })
        if let updateControlUIwork = self.configure?.updateControlUIwork {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: updateControlUIwork)
        }
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
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
}

extension BBTVPlayeriOSPlayPauseView: BBTVPlayeriOSPlayPauseDelegate {
    public func setUpdateUI() {
        self.updateUI()
    }
}
