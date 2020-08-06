//
//  BBTVPlayeriOSLiveStyleView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 19/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSLiveStyleView: UIView {
    private weak var container: UIViewController?
    public var liveLabel: UIButton = UIButton()
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?){
        self.container = container
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
        self.liveLabel.isHidden = true
        self.liveLabel.backgroundColor = UIColor.systemRed.withAlphaComponent(0.7)
        self.liveLabel.clipsToBounds = true
        self.liveLabel.layer.cornerRadius = 4.0
        self.liveLabel.layer.masksToBounds = true
        liveLabel.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(liveLabel)
        
        NSLayoutConstraint.activate([
            liveLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            liveLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            liveLabel.topAnchor.constraint(equalTo: self.topAnchor),
            liveLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


