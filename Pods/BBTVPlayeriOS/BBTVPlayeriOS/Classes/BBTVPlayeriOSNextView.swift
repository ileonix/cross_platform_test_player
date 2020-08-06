//
//  BBTVPlayeriOSNext.swift
//  BBTVPlayeriOS
//
//  Created by Chanon Purananunak on 13/5/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSNextView: UIView {
    var control: BBTVPlayeriOS? //AVPlayerViewController?
    var imageView: UIImageView?
    private var DurationLabel: UILabel = UILabel()
    public var progress: Double?
    public var titleButton: BBTVPlayeriOSTitleView?
    
    public var player: AVPlayer? {
        didSet {
            //Status as LIVE Video
            if let duration = player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if durationSeconds >= 0 {
                    print("CHANONP Next \(self.control?.avq?.currentItem?.canStepForward)")
                    
                    var currentItemIndex = 0
                    var lastIndex = 0
                    if let items = self.control?.avPlayerItems.enumerated() {
                        for (index, item) in self.control!.avPlayerItems.enumerated() {
                            if item == self.control?.avq?.currentItem {
                                currentItemIndex = index
                            }
                            lastIndex = index
                        }
                    }
                    
                    if currentItemIndex == lastIndex {
                        self.isHidden = true
                        print("CHANONP Next hidden 2 \(self.control?.avq?.currentItem?.canStepForward)")
                    } else {
                        self.isHidden = false
                        print("isHidden false")
                    }
                    self.titleButton?.titleLabel.text = (self.configure?.names[currentItemIndex] ?? "-")
                } else {
                    self.isHidden = true
                    print("isHidden true")
                }
            }
        }
    }
    
    public var configure : BBTVPlayeriOSConfigure?
    private weak var container: UIViewController?
    var isAutoPlay: Bool {
        return self.configure?.isAutoPlay ?? false
    }
    
    var isPlaying: Bool {
        return (self.configure?.isPlaying ?? false) && isAutoPlay
    }

    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        self.container = container
        self.configure = configure
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
        imageView?.image = self.loadImageBundle(named: "NextEpisode")
    }
    
    private func setBackgroundImage(name: String) {
        UIGraphicsBeginImageContext(frame.size)
        UIImage(named: name)?.draw(in: bounds)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        var avpItems: [AVPlayerItem] = []
        var currentItemIndex = 0
        var lastIndex = 0
        for (index, item) in self.control!.avPlayerItems.enumerated() {
            avpItems.append(item)
            if item == self.control?.avq?.currentItem {
                currentItemIndex = index
            }
            lastIndex = index
        }
        
        if currentItemIndex + 1 <= lastIndex {
            self.control?.avq?.removeAllItems()
            self.control?.avq?.replaceCurrentItem(with: self.control?.avPlayerItems[currentItemIndex+1])
            self.control?.avq?.seek(to: .zero)
            if isPlaying {
                self.control?.avq?.play()
            } else {
                self.control?.avq?.pause()
            }
        }
        
        for (index,item) in avpItems.enumerated() {
            if index + 1 <= lastIndex {
                if index == 0 {
                    self.control?.avq?.canInsert(avpItems[index], after: nil)
                } else {
                    self.control?.avq?.canInsert(avpItems[index+1], after: avpItems[index])
                }
            }
        }       
        print("Next to  \(currentItemIndex+1)")
        self.titleButton?.titleLabel.text = (self.configure?.names[currentItemIndex+1] ?? "-")
    }
}
