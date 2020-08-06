//
//  PlaylistTableContainer.swift
//  BBTVPlayeriOS_Example
//
//  Created by Chanon Purananunak on 11/6/2563 BE.
//  Copyright © 2563 CocoaPods. All rights reserved.
//

import UIKit

class PlaylistTableContainer: UIView {
    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    func commonInit(){
        Bundle.main.loadNibNamed("PlaylistTableContainerView", owner: self, options: nil)
        self.mContentView.backgroundColor = .clear
        
        self.titleLabel.textColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 250/250, alpha: 0.6)
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
        
        self.addSubview(mContentView)
        
        self.mContentView.translatesAutoresizingMaskIntoConstraints = false
        self.mContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.mContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.mContentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.mContentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setText(text: String){
        self.titleLabel.text = text
    }
}

