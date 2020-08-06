//
//  BBTVPlayeriOSSliderView.swift
//  BBTVPlayeriOS
//
//  Created by Chanon Purananunak on 29/4/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public protocol BBTVPlayeriOSSliderDelegate {
    func setDurationProgress(second: Double)
}

public class BBTVPlayeriOSSliderView: UIView {
    
}/*UISlider {
    var delegatePlayPause: BBTVPlayeriOSPlayPauseDelegate?
    var delegateDuration: BBTVPlayeriOSDurationDelegate?
    @IBInspectable var trackHeight: CGFloat = 3
    @IBInspectable var thumbRadius: CGFloat = 15
    public var isThumbHaveBorder: Bool = false
    private var isOldPlaying: Bool = false
    
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = color != nil ? color : UIColor.white
        if isThumbHaveBorder {
            thumb.layer.borderWidth = 0.4
            thumb.layer.borderColor = UIColor.darkGray.cgColor
        }
        return thumb
    }()
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    private func thumbImageHighlight(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
    public var color: UIColor?
    public var progress: Double?
    public var player: AVPlayer? {
        didSet {
            if let isSeeking = configure?.isSeeking, !isSeeking {
                if let duration = player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    if durationSeconds >= 0 {
                        self.maximumValue = Float(durationSeconds)
                        self.minimumValue = 0.0
                    }
                    self.isContinuous = true
                    if var seconds = progress {
                        let progress = Float(seconds / durationSeconds)
                        if seconds > durationSeconds {
                            seconds = durationSeconds
                        }
                        self.value = Float(seconds)
                        DispatchQueue.main.async {
                            let sDurationSeconds = Utility.formatSecondsToHMS(durationSeconds)
                            var sSecounds = Utility.formatSecondsToHMS(seconds)
                            if sDurationSeconds.count >= 8 {
                                sSecounds = Utility.formatSecondsToHMS(seconds, eStyle: .long)
                            }
                            if sDurationSeconds != "LIVE" {
                                self.setUpUI(visible: true)
                            } else {
                                self.setUpUI(visible: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public var configure : BBTVPlayeriOSConfigure?
    //    public var duration: CMTime?
    
    private weak var container: UIViewController?
    var isAutoPlay: Bool {
        return self.configure?.isAutoPlay ?? false
    }
    
    var isPlaying: Bool {
        // return (player?.rate != 0 && player?.error == nil) && isAutoPlay
        return (self.configure?.isPlaying ?? false) && isAutoPlay
    }
    
    public func setup(in container: UIViewController, configure : BBTVPlayeriOSConfigure?, color: UIColor?){
        self.container = container
        self.configure = configure
        self.color = color
        self.addTarget(self, action: #selector(playbackSliderValueChanged(_:event:)), for: .touchDown)
        self.addTarget(self, action: #selector(playbackSliderValueChanged(_:event:)), for: .valueChanged)
        self.addTarget(self, action: #selector(playbackSliderEnd), for: .touchUpInside)
        self.addTarget(self, action: #selector(playbackSliderEnd), for: .touchUpOutside)
        self.addTarget(self, action: #selector(playbackSliderEnd), for: .touchCancel)
        
        updatePosition()
        setUpUI(visible: true)
    }
    
    public func setUpUI(visible: Bool){
        if visible {
            self.trackHeight = CGFloat(3)
            self.thumbRadius = CGFloat(20)
            let thumb = thumbImage(radius: thumbRadius)
            let thumbHighlight = thumbImageHighlight(radius: 30)
            self.setThumbImage(thumb, for: .normal)
            self.setThumbImage(thumbHighlight, for: .highlighted)
            self.minimumTrackTintColor = color
            self.maximumTrackTintColor = color?.withAlphaComponent(0.5)
        } else {
            self.thumbRadius = CGFloat(0)
            let thumb = thumbImage(radius: thumbRadius)
            let thumbHighlight = thumbImageHighlight(radius: 0)
            self.setThumbImage(thumb, for: .normal)
            self.setThumbImage(thumbHighlight, for: .highlighted)
            self.minimumTrackTintColor = .clear
            self.maximumTrackTintColor = .clear
        }
    }
    
    func updatePosition(){
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        var guide: AnyObject = superview
        if #available(iOS 11.0, *) {
            guide = superview.safeAreaLayoutGuide
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
    
    func showControlUI() {
        guard let _control = superview, (configure?.isShowControl ?? false) else { return }
        print("showControlUI: slide")
        self.configure?.updateControlUIwork?.cancel()
        self.configure?.updateControlUIwork = DispatchWorkItem(block: {
            UIView.animate(withDuration: 0.25, animations: {
                _control.alpha = 1
            }) { (bool) in
                print("แสดง")
                self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                    if self.isPlaying == true {
                        self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                            print("แสดง-> ออก")
                            UIView.animate(withDuration: 0.45, animations: {
                                _control.alpha = 0
                            })
                        })
                        if let updateControlUIwork = self.configure?.updateControlUIwork {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: updateControlUIwork)
                        }
                    } else {
                        print("แสดง-> ไม่ออก")
                    }
                })
                if let updateControlUIwork = self.configure?.updateControlUIwork {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: updateControlUIwork)
                }
            }
        })
        if let updateControlUIwork = self.configure?.updateControlUIwork {
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: updateControlUIwork)
        }
    }
    
    @objc func playbackSliderValueChanged(_ sender: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                configure?.isSeeking = true
                self.showControlUI()
                self.isOldPlaying = self.isPlaying
                delegatePlayPause?.setUpdateUI()
                print("handle drag began")
                break
            case .moved:
                print("handle drag moved")
                self.showControlUI()
                self.delegateDuration?.setDurationProgress(second: Double(sender.value))
                break
            default:
                break
            }
        }
    }
    
    @objc func playbackSliderEnd(_ sender: UISlider, event: UIEvent) {
        print("handle drag ended")
        self.player?.pause()
        if let currentTime = self.player?.currentItem {
            let newCurrentTime = Float64(sender.value)
            let seekToTime = CMTimeMakeWithSeconds(newCurrentTime, preferredTimescale: 600)
            if self.isOldPlaying {
                self.player?.seek(to: seekToTime, completionHandler: { (bool) in
                    self.player?.play()
                    self.configure?.isSeeking = false
                    self.hideControlUI()
                })
            } else {
                self.player?.seek(to: seekToTime, completionHandler: { (bool) in
                    self.player?.pause()
                    self.configure?.isSeeking = false
                    self.showControlUI()
                })
            }
        }
    }
}

extension BBTVPlayeriOSSliderView: BBTVPlayeriOSSliderDelegate {
    public func setDurationProgress(second: Double) {
        print("BBTVPlayeriOSSliderView-time:", second)
    }
}
*/
