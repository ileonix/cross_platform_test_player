//
//  BBTVPlayeriOSPlaylistTableView.swift
//  BBTVPlayeriOS
//
//  Created by Chanon Purananunak on 15/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSPlaylistTableView: UIView {
    var delegate: BBTVPlayeriOSControlDelegate?
    var playlistTableView : UITableView!
    var playlistViewCell: PlaylistViewCell!
    var control: BBTVPlayeriOS? //AVPlayerViewController?
    public var player: AVPlayer?
    public var configure : BBTVPlayeriOSConfigure?
    private weak var container: UIViewController?
    var isPlaying: Bool {
        return player?.rate != 0 && player?.error == nil
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        addGestureRecognizer(gesture)
        self.configure = configure
        self.container = container
        
        setTableView()
        setUpUI()
        updatePosition()
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if let _tableView = self.playlistTableView {
            _tableView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(_tableView)
            _tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            _tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            _tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            _tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
    }
    
    public func setUpUI(){
        
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer){
        print("touch PlaylistViewCell")
        let point = sender.location(in: self.playlistTableView)
        print("touch point:", point)
        
        if let indexPath = self.playlistTableView.indexPathForRow(at: point) {
            print("touch indexPath:", indexPath)
            if let cell = self.playlistTableView.cellForRow(at: indexPath) as? PlaylistViewCell {
                if let touchPoint = cell.touchPoint {
                    print("touch touchPoint \(touchPoint)")
                    var avpItems: [AVPlayerItem] = []
                    var currentItemIndex = 0
                    for (index, item) in self.control!.avPlayerItems.enumerated() {
                        avpItems.append(item)
                        currentItemIndex = index
                    }
                    
                    self.control?.avq?.removeAllItems()
                    self.control?.avq?.replaceCurrentItem(with: self.control?.avPlayerItems[indexPath.row])
                    self.control?.avq?.seek(to: .zero)
                    
                    for (index,item) in avpItems.enumerated() {
                        if index < currentItemIndex {
                            self.control?.avq?.canInsert(avpItems[index+1], after: avpItems[index])
                        }
                        print("touch \(index):\(currentItemIndex)")
                    }
                    self.delegate?.touchPlayList()
                }
            }
        }
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
            
            if let items = configure?.playlist {
                for (index,item) in items.enumerated() {
                    print("playlist: \(index) \(item)")
                }
            }
            
            return initialview
        }()
        playlistTableView.reloadData()
    }
}
extension BBTVPlayeriOSPlaylistTableView: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configure?.playlist.count ?? 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.playlistTableView.dequeueReusableCell(withIdentifier: PlaylistViewCell.identifier + "2", for: indexPath) as! PlaylistViewCell
        cell.playlistItemView.setText(text: configure?.playlist[indexPath.row] ?? "item nil")
        cell.backgroundColor = UIColor.cyan.withAlphaComponent(0.3)
        return cell
    }
}

