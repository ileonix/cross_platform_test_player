//
//  BBTVPlayeriOSFullScreenView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 15/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSFullScreenView: UIView {
    var delegate: BBTVPlayeriOSControlDelegate?
    var imageView: UIImageView?
    public var player: AVPlayer?
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
        imageView?.image = self.loadImageBundle(named: "Fullscreen")
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.touchFullScreen()
    }
}
