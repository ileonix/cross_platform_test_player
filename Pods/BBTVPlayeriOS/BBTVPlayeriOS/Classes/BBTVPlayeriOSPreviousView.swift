//
//  BBTVPlayeriOSPrevious.swift
//  BBTVPlayeriOS
//
//  Created by Chanon Purananunak on 13/5/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSPreviousView: UIView {
    var control: BBTVPlayeriOS? 
    var imageView: UIImageView?
    public var player: AVPlayer?
    public var configure : BBTVPlayeriOSConfigure?
    private weak var container: UIViewController?
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }

    public func setup(in container: UIViewController, configure: BBTVPlayeriOSConfigure?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        self.container = container
        self.configure = configure
        updatePosition()
        setUpUI()
    }
    
    func updatePosition() {
        self.backgroundColor = .systemGreen
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
        imageView?.image = self.loadImageBundle(named: "PreviousEpisode")
    }
    
    private func setBackgroundImage(name: String) {
        UIGraphicsBeginImageContext(frame.size)
        UIImage(named: name)?.draw(in: bounds)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        print("CHANONP Previous")
        let currentItem = self.player?.currentItem
        if (currentItem?.canStepBackward ?? false) && isPlaying {
            if let items = self.control?.avPlayerItems {
                var index: Int = 0
                for item in items {
                    if item == self.control?.avq?.currentItem && index != 0 {
                        print("CHANON current and match: ",index)
                        self.player?.replaceCurrentItem(with: items[index-1])
                    } else {
                        print("CHANON current and not match: ",index)
                    }
                    index+=1
                }
            }
            print("CHANONP can Previous")
        } else {
            print("CHANONP can't Previous")
        }
    }
}
