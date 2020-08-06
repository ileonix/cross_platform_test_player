//
//  PlaylistViewCell.swift
//  BBTVPlayeriOS_Example
//
//  Created by Chanon Purananunak on 11/6/2563 BE.
//  Copyright © 2563 CocoaPods. All rights reserved.
//
import UIKit

class PlaylistViewCell: UITableViewCell {
    static let identifier: String = "PlaylistViewCell"
    var playlistItemView: PlaylistTableContainer!
    var touchPoint: CGPoint? = .zero
    var touch: Set<UITouch>?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView()  {
        self.playlistItemView = {
            let mInitailView: PlaylistTableContainer = PlaylistTableContainer()
            mInitailView.commonInit()//.commonInit(pointColor: self.playlistItemView.backgroundColor)
            mInitailView.translatesAutoresizingMaskIntoConstraints = false
            mInitailView.backgroundColor = UIColor.clear
            return mInitailView
        }()
        
        self.contentView.addSubview(self.playlistItemView)
        
        self.playlistItemView.translatesAutoresizingMaskIntoConstraints = false
        self.playlistItemView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        self.playlistItemView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.playlistItemView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.playlistItemView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchPoint = touches.first?.location(in: self)
        self.touch = touches
    }
}
