//
//  BBTVPlayeriOSPlaylistView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 15/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSPlaylistView: UIView {
    var delegate: BBTVPlayeriOSControlDelegate?
    var playlistTableView : UITableView!
    var playlistViewCell: PlaylistViewCell!
    
    var control: BBTVPlayeriOS?
    var imageView: UIImageView?
    public var player: AVPlayer? {
        didSet {
            if let duration = player?.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                if durationSeconds >= 0,
                    (self.configure?.playlist.count ?? 0) > 1,
                    !(configure?.isPlaylistMode ?? false) {
                    self.isHidden = false
                } else {
                    self.isHidden = true
                }
            }
        }
    }
    
    public var configure : BBTVPlayeriOSConfigure?
    private weak var container: UIViewController?
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(gesture)
        self.configure = configure
        self.container = container
        updatePosition()
        setUpUI()
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
        imageView?.image = self.loadImageBundle(named: "Playlist")
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        print("show playlist.....")
        self.delegate?.touchPlayList()
    }
    
    func setTableView() {
        self.playlistTableView = {
            let initialview = UITableView()
            
            initialview.register(PlaylistViewCell.self, forCellReuseIdentifier: PlaylistViewCell.identifier + "2")
            initialview.dataSource = self
            initialview.delegate = self
            initialview.estimatedRowHeight = 150
            initialview.rowHeight = UITableView.automaticDimension
            
            initialview.setDefaultCH7HD(bHaveFooter: true)//.setDefaultCH7HD(sSeparatorStyle: .none, bHaveFooter: true)
            initialview.translatesAutoresizingMaskIntoConstraints = false
            return initialview
        }()
    }
}
extension BBTVPlayeriOSPlaylistView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configure?.playlist.count ?? 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.playlistTableView.dequeueReusableCell(withIdentifier: PlaylistViewCell.identifier + "2", for: indexPath) as! PlaylistViewCell
        cell.playlistItemView.setText(text: configure?.playlist[indexPath.row] ?? "item nil")
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.cyan.withAlphaComponent(0.3)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PlaylistViewCell {
            if let touchPoint = cell.touchPoint {
                switch true {
                case cell.playlistItemView.titleLabel.frame.contains(touchPoint):
                    print("playlist titleLabel")
                case cell.playlistItemView.playButton.frame.contains(touchPoint):
                    print("playlist PlayButton")
                    self.control?.avq?.replaceCurrentItem(with: self.control?.avPlayerItems[indexPath.row])
                default:
                    break
                }
            }
        }
    }
    
}
