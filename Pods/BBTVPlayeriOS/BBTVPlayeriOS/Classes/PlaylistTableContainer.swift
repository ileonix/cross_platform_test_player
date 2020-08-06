//
//  PlaylistTableContainer.swift
//  BBTVPlayeriOS_Example
//
//  Created by Chanon Purananunak on 11/6/2563 BE.
//  Copyright © 2563 CocoaPods. All rights reserved.
//

import UIKit

class PlaylistTableContainer: UIView {
   var mContentView: UIView!
    var titleLabel: UILabel!
    var playButton: UIButton!
    
    func commonInit(){
        self.mContentView = UIView()
         self.titleLabel = UILabel()
        self.playButton = UIButton(type: .custom)
//        let bundle = Bundle(for: self.classForCoder)
//        bundle.loadNibNamed("PlaylistTableContainerView", owner: self, options: nil)
        self.mContentView.backgroundColor = .clear
        
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        
        self.playButton.isUserInteractionEnabled = false
        self.playButton.setImage(self.loadImageBundle(named:"Play Button") ?? UIImage(), for: .normal)
        self.playButton.tintColor = .black
//        self.playButton.backgroundColor = .red
        
        self.addSubview(mContentView)
        self.mContentView.addSubview(titleLabel)
         self.mContentView.addSubview(playButton)
        
        self.mContentView.translatesAutoresizingMaskIntoConstraints = false
        self.mContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.mContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.mContentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.mContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.mContentView.topAnchor).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.mContentView.leftAnchor, constant: 16.0).isActive = true
//        self.titleLabel.rightAnchor.constraint(equalTo: self.mContentView.rightAnchor).isActive = true
        self.titleLabel.bottomAnchor.constraint(equalTo: self.mContentView.bottomAnchor).isActive = true
        
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.centerYAnchor.constraint(equalTo: self.mContentView.centerYAnchor).isActive = true
        self.playButton.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 16.0).isActive = true
        self.playButton.widthAnchor.constraint(equalToConstant: 64.0).isActive = true
        self.playButton.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
                self.playButton.rightAnchor.constraint(equalTo: self.mContentView.rightAnchor).isActive = true
//        self.playButton.bottomAnchor.constraint(equalTo: self.mContentView.bottomAnchor).isActive = true
    }
    
    func setText(text: String){
        self.titleLabel.text = text
    }
}

