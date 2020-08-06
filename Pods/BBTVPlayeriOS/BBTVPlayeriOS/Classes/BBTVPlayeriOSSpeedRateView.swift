//
//  BBTVPlayeriOSSpeedRateView.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 22/4/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSSpeedRateView: UIView {
    public var player: AVPlayer?
    public var configure : BBTVPlayeriOSConfigure?
    var title: UILabel?
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
    
    public func setUpUI(speedRate: Float? = 1.0) {
        if let _speedRate = speedRate {
            self.configure?.speedRate = _speedRate
            title?.text = "\(_speedRate)x"
            if self.isPlaying == true {
                self.player?.rate = _speedRate
            }
        } else {
            title?.text = "1.0x"
        }
    }
    
    func updatePosition() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        title = UILabel()
        if let _title = title {
            _title.textAlignment = .center
            _title.backgroundColor = .systemYellow
            _title.translatesAutoresizingMaskIntoConstraints = false
            addSubview(_title)
            _title.topAnchor.constraint(equalTo: topAnchor).isActive = true
            _title.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            _title.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            _title.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        let rateActionSheetController: UIAlertController = UIAlertController(title: "", message: "ความเร็วในการเล่น", preferredStyle: .actionSheet)
        
        let halfSpeedActionButton = UIAlertAction(title: "0.5", style: .default) { _ in
            let speedRate : Float?  = 0.5
            self.setUpUI(speedRate: speedRate)
        }
        rateActionSheetController.addAction(halfSpeedActionButton)
        
        let quarter3in4SpeedActionButton = UIAlertAction(title: "0.75", style: .default) { _ in
            let speedRate : Float?  = 0.75
            self.setUpUI(speedRate: speedRate)
        }
        rateActionSheetController.addAction(quarter3in4SpeedActionButton)
        
        let normalSpeedActionButton = UIAlertAction(title: "ปกติ", style: .default) { _ in
            let speedRate : Float?  = 1.0
            self.setUpUI(speedRate: speedRate)
        }
        rateActionSheetController.addAction(normalSpeedActionButton)
        
        let more1in4SpeedActionButton = UIAlertAction(title: "1.25", style: .default) { _ in
            let speedRate : Float?  = 1.25
            self.setUpUI(speedRate: speedRate)
        }
        rateActionSheetController.addAction(more1in4SpeedActionButton)
        
        let more3in4SpeedActionButton = UIAlertAction(title: "1.75", style: .default) { _ in
            let speedRate : Float?  = 1.75
            self.setUpUI(speedRate: speedRate)
        }
        rateActionSheetController.addAction(more3in4SpeedActionButton)
        
        let doubleSpeedActionButton = UIAlertAction(title: "2.0", style: .default) { _ in
            let speedRate : Float?  = 2.0
            self.setUpUI(speedRate: speedRate)
        }
        rateActionSheetController.addAction(doubleSpeedActionButton)
        
        container?.present(rateActionSheetController, animated: true, completion: nil)
    }
}
