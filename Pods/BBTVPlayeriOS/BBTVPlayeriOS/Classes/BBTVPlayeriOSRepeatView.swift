//
//  BBTVPlayeriOSRepeatView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 19/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSRepeatView: UIView {
    var delegate: BBTVPlayeriOSRepeatDelegate?
    var imageView: UIImageView?
    var container: UIViewController?
    
    public func setup(in container: UIViewController) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(gesture)
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
    public func setUpUI() {
        imageView?.image = self.loadImageBundle(named: "Replay")
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        self.delegate?.touchRepeat()
    }
}
