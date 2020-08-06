import AVFoundation
import AVKit
import UIKit
import BrightcovePlayerSDK
import Just

enum ActivePlayer {
    case content
    case ad
    case unknown
}

public protocol BBTVPlayeriOSDelegate {
    func playbackSession(_ session: AVPlayer?, didProgressTo progress: TimeInterval)
}

public class BBTVPlayeriOS: UIView {
    public var avq: AVQueuePlayer?
    public var avPlayerItems: [AVPlayerItem] = []
    public var timeObserver: Any?
    //    public var player: AVPlayer?
    public var playerLayer: AVPlayerLayer?
    public var setLayoutSize: Bool = false
    
    public init(configure: BBTVPlayeriOSConfigure? = nil, control: BBTVPlayeriOSControl? = nil, indicator: BBTVPlayeriOSIndicatorViewController? = nil, repeatPlayer: BBTVPlayeriOSRepeatViewController? = nil) {
        super.init(frame: .zero)
        
        if let configure = configure {
            self.configure = configure
        }
        
        if let control = control {
            self.control = control
        }
        
        if let indicator = indicator {
            self.indicator = indicator
        }
        
        if let repeatPlayer = repeatPlayer {
            self.repeatPlayer = repeatPlayer
        }
        
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var shouldAutoRepeat: Bool = false {
        didSet {
            if oldValue == shouldAutoRepeat { return }
            self.configure?.isAutoRepeat = shouldAutoRepeat
        }
    }
    
    var isRepeating: Bool = false {
        didSet {
            if oldValue == isRepeating { return }
            self.configure?.isRepeating = isRepeating
        }
    }
    
    public var isAutoPlay: Bool = false {
        didSet {
            if oldValue == isAutoPlay { return }
            self.configure?.isAutoPlay = isAutoPlay
        }
    }
    
    public var showsCustomControls: Bool = false {
        didSet {
            if !showsCustomControls  {
                self.hideLiveControlUI()
            }
            if oldValue == showsCustomControls { return }
            if let configure = configure {
                self.configure = configure
                self.configure?.isShowControl = showsCustomControls
                if showsCustomControls {
                    self.showControlUI()
                    self.showLiveControlUI()
                    print("show: 4")
                } else {
                    self.hideControlUI()
                    self.hideLiveControlUI()
                    print("hide: 7")
                }
            }
        }
    }
    
    @objc fileprivate func itemDidFinishPlaying() {
        configure?.isSeeking = false
        // NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        print("yes play begin")
        if self.avPlayerItems.count > 1 {
            print("yes play >1")
            if self.avq?.currentItem == self.avPlayerItems.last {
                print("yes play >1 last")
                self.avq?.removeAllItems()
                for (index,item) in self.avPlayerItems.enumerated() {
                    if index + 1 < self.avPlayerItems.count {
                        print("yes play >1 \(index)")
                        if index == 0 {
                            self.avq?.insert(self.avPlayerItems[index], after: nil)
                        } else {
                            self.avq?.insert(self.avPlayerItems[index+1], after: self.avPlayerItems[index])
                        }
                    }
                }
                self.isRepeating = true
                if shouldAutoRepeat {
                    self.isRepeating = false
                    self.avq?.seek(to: .zero)
                } else {
                    //                    self.avq?.pause()
                }
            } else {
                //Do next for playlist
                var avpItems: [AVPlayerItem] = []
                var currentItemIndex = 0
                var lastIndex = 0
                for (index, item) in self.avPlayerItems.enumerated() {
                    avpItems.append(item)
                    if item == self.avq?.currentItem {
                        currentItemIndex = index
                    }
                    lastIndex = index
                }
                
                if currentItemIndex + 1 <= lastIndex {
                    self.avq?.removeAllItems()
                    self.avq?.replaceCurrentItem(with: self.avPlayerItems[currentItemIndex+1])
                    self.avq?.seek(to: .zero)
                }
                
                for (index,item) in avpItems.enumerated() {
                    if index + 1 <= lastIndex {
                        if index == 0 {
                            self.avq?.canInsert(avpItems[index], after: nil)
                        } else {
                            self.avq?.canInsert(avpItems[index+1], after: avpItems[index])
                        }
                    }
                }
            }
        } else {
            self.avq?.removeAllItems()
            if let firstAVPlayerItems = self.avPlayerItems.first {
                print("yes play at\(firstAVPlayerItems)")
                self.avq?.insert(firstAVPlayerItems, after: nil)
                self.isRepeating = true
                if shouldAutoRepeat {
                    self.isRepeating = false
                    self.avq?.seek(to: .zero)
                } else {
                    //                    self.avq?.pause()
                }
            } else {
                print("yes not play in else")
            }
        }
    }
    
    //MARK: function from BBTVPlayerV2 For Brightcove
    var brigtcovePlayer: BBTVPlayeriOSBrightCove?
    public var bcVideo: BCVideo? {
        didSet {
            if bcVideo == nil { return }
            print("BCove: didset \(bcVideo)")
            brigtcovePlayer = BBTVPlayeriOSBrightCove.init(playlistItemContext: self.playerItemContext, avq: self.avq, playerLayer: self.playerLayer, setLayoutSize:  self.setLayoutSize, bcVideo: self.bcVideo!, configure: self.configure, service: configure?.bcService, core: self)
            self.avq = brigtcovePlayer?.avQueuePlayer
            self.playerLayer = brigtcovePlayer?.playerLayer
            self.setLayoutSize = ((brigtcovePlayer?.setLayoutSize) != nil)
            //            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
            //            NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        }
    }
    //MARK: End function from BBTVPlayerV2 For Brightcove
    
    //MARK: function from BBTVPlayerKit For DRM
    var drmPlayer: BBTVPlayeriOSDRM?
    public struct ObserverContexts {
        static var playerItemStatus = 0
        static var playerItemStatusKey =  #keyPath(AVPlayerItem.status)
    }
    @objc open var srcDrm: String? {
        didSet {
            drmPlayer = BBTVPlayeriOSDRM.init(core: self, isNewAsset: true, srcDrm: srcDrm)
        }
    }
    //MARK: End function from BBTVPlayerKit For DRM
    
    deinit {
        if let _coverImage = self.coverImage {
            _coverImage.view.isHidden = true
            _coverImage.willMove(toParent: nil)
            _coverImage.view.removeFromSuperview()
            _coverImage.removeFromParent()
        }
        
        //MARK: From BBTVPlayerKit For DRM
        self.drmPlayer?.removePlayerItemObservers(playerItem: self.avq?.currentItem)
        self.drmPlayer?.removeNotificationCenter()
        //MARK: END From BBTVPlayerKit For DRM
    }
    
    public var configure : BBTVPlayeriOSConfigure?
    public var control: BBTVPlayeriOSControl?
    public var coverImage: UIViewController?
    public var repeatPlayer: BBTVPlayeriOSRepeatViewController?
    public var controlDelegate: BBTVPlayeriOSDelegate?
    
    public var indicator: BBTVPlayeriOSIndicatorViewController?
    
    public var playerItemContext: String = "playerItemContext"
    
    private var isPlaying: Bool {
        let _isPlaying = self.avq?.rate != 0 && self.avq?.error == nil
        return _isPlaying
    }
    
    public var isLoading: Bool = false {
        didSet {
            if isLoading {
                self.hideControlUI()
                print("hide: 8")
            }
        }
    }
    
    @objc func tapped(_ sender: UITapGestureRecognizer) {
        if !self.isLoading {
            self.updateControlUI()
        }
    }
    
    func updateControlUI() {
        if let _control = self.control {
            if (configure?.isPlaylistMode ?? false) {
                print("ไม่ทำอะไร")
                return
            }
            if _control.fadeHideView.alpha > 0 || self.isRepeating {
                print("hide")
                self.hideControlUI()
                print("hide: 1")
            } else {
                print("show")
                self.showControlUI()
                print("show: 1")
            }
        }
    }
    
    func showRepeat() {
        if let _repeatPlayer = self.repeatPlayer {
            _repeatPlayer.view.alpha = 1.0
        }
    }
    
    func hideRepeat() {
        if let _repeatPlayer = self.repeatPlayer {
            _repeatPlayer.view.alpha = 0.0
        }
    }
    
    func hideLiveControlUI() {
        if let _control = self.control {
            _control.noFadeHideView.alpha = 0
        }
    }
    
    func showLiveControlUI() {
        if let _control = self.control {
            UIView.animate(withDuration: 0.45, animations: {
                _control.noFadeHideView.alpha = 1
            })
        }
    }
    
    func hideControlUI() {
        if let _control = self.control {
            if self.isPlaying == true {
                configure?.updateControlUIwork?.cancel()
                configure?.updateControlUIwork = DispatchWorkItem(block: {
                    UIView.animate(withDuration: 0.45, animations: {
                        _control.fadeHideView.alpha = 0
                    })
                })
                if let updateControlUIwork = configure?.updateControlUIwork {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: updateControlUIwork)
                }
            }
        }
    }
    
    func showControlUI() {
        if let _control = self.control, self.showsCustomControls {
            print("showControlUI: playerIOS")
            configure?.updateControlUIwork?.cancel()
            configure?.updateControlUIwork = DispatchWorkItem(block: {
                UIView.animate(withDuration: 0.25, animations: {
                    _control.fadeHideView.alpha = 1
                }) { (bool) in
                    print("แสดง")
                    self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                        if self.isPlaying == true {
                            self.configure?.updateControlUIwork = DispatchWorkItem(block: {
                                print("แสดง-> ออก")
                                UIView.animate(withDuration: 0.45, animations: {
                                    _control.fadeHideView.alpha = 0
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute:updateControlUIwork)
                    }
                }
            })
            if let updateControlUIwork = configure?.updateControlUIwork {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: updateControlUIwork)
            }
        }
    }
    
    func setUpUI()  {
        self.setLayoutSize = false
        let oBBTVPlayeriOSCoverImageViewController = BBTVPlayeriOSCoverImageViewController()
        oBBTVPlayeriOSCoverImageViewController.setImage(image: self.configure?.coverImage)
        self.coverImage = oBBTVPlayeriOSCoverImageViewController
        
        guard let configure = configure else {
            print("nil configure")
            DispatchQueue.main.async {
                let holderView = UIView()
                holderView.backgroundColor = .black
                holderView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(holderView)
                self.bringSubviewToFront(holderView)
                
                holderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                holderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                holderView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                holderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                
                let holderText = UILabel()
                holderText.textColor = .white
                holderText.text = "nil configure"
                holderText.translatesAutoresizingMaskIntoConstraints = false
                holderView.addSubview(holderText)
                holderView.bringSubviewToFront(holderText)
                
                holderText.centerYAnchor.constraint(equalTo: holderView.centerYAnchor).isActive = true
                holderText.centerXAnchor.constraint(equalTo: holderView.centerXAnchor).isActive = true
            }
            return
        }
        
        self.control?.Configure = configure
        
        if let videoURL = URL(string: configure.url ?? "" ) {
            let assetKeys = [
                "playable",
                "hasProtectedContent"
            ]
            let asset = AVAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
            playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            playerItem.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
            let player = AVQueuePlayer(playerItem: playerItem)//AVPlayer(playerItem: playerItem)
            self.avq = player
            self.avq?.play()
            
            if let player = self.avq {
                self.playerLayer = AVPlayerLayer(player: player)
                if let layer = playerLayer {
                    layer.videoGravity = .resize
                    self.layer.sublayers?
                        .filter { $0 is AVPlayerLayer }
                        .forEach { $0.removeFromSuperlayer()
                            print("ภภภภภภภ")
                    }
                    self.setLayoutSize = true
                    self.layer.addSublayer(layer)
                }
                
                if let superView = self.superview {
                    self.layer.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
                }
            }
        }
        
        //Set AVQueuePlayer
        if let videoPlaylistStringURL: [String] = configure.playlist ?? [] {
            var videoURL = URL(string: "")
            for item in videoPlaylistStringURL {
                videoURL = URL(string: item)
                
                let assetKeys = [
                    "playable",
                    "hasProtectedContent"
                ]
                
                let asset = AVAsset(url: videoURL!)
                let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
                playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
                playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
                playerItem.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
                playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &playerItemContext)
                
                print("CHANONPP ",playerItem.tracks.description)
                avPlayerItems.append(playerItem)
            }
            
            avq = AVQueuePlayer(items: avPlayerItems)
            self.avq?.play()
            //            self.player = avq
            //            self.player?.play()
            
            if let player = self.avq {//self.player {
                self.playerLayer = AVPlayerLayer(player: player)
                if let layer = playerLayer {
                    layer.videoGravity = .resize
                    self.layer.sublayers?
                        .filter { $0 is AVPlayerLayer }
                        .forEach { $0.removeFromSuperlayer()
                    }
                    self.setLayoutSize = true
                    self.layer.addSublayer(layer)
                }
                
                if let superView = self.superview {
                    self.layer.frame = CGRect(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height)
                }
            }
        }
        
        if let _coverImage = self.coverImage {
            print("Set indicator set coverimage")
            _coverImage.view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(_coverImage.view)
            self.bringSubviewToFront(_coverImage.view)
            _coverImage.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            _coverImage.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            _coverImage.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            _coverImage.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        if let _indicator = self.indicator {
            print("Set indicator ready to play")
            _indicator.view.isUserInteractionEnabled = false
            _indicator.view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(_indicator.view)
            self.bringSubviewToFront(_indicator.view)
            self.indicator?.delegate = _indicator
            _indicator.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            _indicator.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            _indicator.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            _indicator.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
        
        //Set DRM source
        print("did obs self.srcDrm \(configure.srcDrm)")
        self.srcDrm = configure.srcDrm
        
        //Set BrightCove source
        brigtcovePlayer?.bcService = configure.bcService
        //        self.bcService = configure.bcService
        self.bcVideo = configure.bcVideo
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped(_:)))
        self.addGestureRecognizer(gesture)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach {
                if setLayoutSize {
                    $0.frame = self.bounds
                }
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard context == &playerItemContext else {
            if object is AVPlayerItem {
                switch keyPath {
                case "playbackBufferEmpty":
                    // Show loader
                    print("playbackBufferEmpty")
                    self.indicator?.delegate?.indicatorStatus(isLoading: true)
                    self.isLoading = true
                case "playbackLikelyToKeepUp":
                    // Hide loader
                    print("playbackLikelyToKeepUp")
                    if let playbackLikelyToKeepUp = self.avq?.currentItem?.isPlaybackLikelyToKeepUp {
                        if playbackLikelyToKeepUp == false {
                            //start the activity indicator
                            print("IsBuffering ")
                            self.indicator?.delegate?.indicatorStatus(isLoading: true)
                            self.isLoading = true
                        } else {
                            //stop the activity indicator
                            print("Buffering completed")
                            self.indicator?.delegate?.indicatorStatus(isLoading: false)
                            self.isLoading = false
                        }
                    } else {
                        print("IsBuffering continue")
                        self.indicator?.delegate?.indicatorStatus(isLoading: true)
                        self.isLoading = true
                    }
                case "playbackBufferFull":
                    // Hide loader
                    print("playbackBufferFull")
                    self.indicator?.delegate?.indicatorStatus(isLoading: false)
                    self.isLoading = false
                default:
                    break
                }
            }
            return
        }
        
        if object is AVPlayerItem {
            if keyPath == #keyPath(AVPlayerItem.status) {
                let status: AVPlayerItem.Status
                // Get the status change from the change dictionary
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                
                // Switch over the status
                switch status {
                case .readyToPlay:
                    print("Player item is ready to play.")
                    
                    if let _configure = self.configure {
                        self.shouldAutoRepeat = _configure.isAutoRepeat
                        if !self.isRepeating {
                            self.isRepeating = _configure.isRepeating
                        }
                        self.showsCustomControls = _configure.isShowControl
                    }
                    
                    if let _control = self.control {
                        _control.view.removeFromSuperview()
                        _control.view.translatesAutoresizingMaskIntoConstraints = false
                        self.addSubview(_control.view)
                        self.bringSubviewToFront(_control.view)
                        _control.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                        _control.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                        _control.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                        _control.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                        _control.playbackSession(self.avq, didProgressTo: 0)
                        if self.showsCustomControls && !self.isRepeating {
                            self.showControlUI()
                            print("show: 2")
                        } else {
                            _control.fadeHideView.alpha = 0.0
                        }
                        _control.view.alpha = 1.0
                        
                        if let _configure = self.configure {
                            self.shouldAutoRepeat = _configure.isAutoRepeat
                            if !self.isRepeating {
                                self.isRepeating = _configure.isRepeating
                            }
                            self.showsCustomControls = _configure.isShowControl
                        }
                        
                        
                        if let duration = self.avq?.currentItem?.duration {
                            let durationSeconds = CMTimeGetSeconds(duration)
                            if var seconds = self.avq?.currentItem?.currentTime().seconds {
                                let progress = Float(seconds / durationSeconds)
                                if seconds > durationSeconds {
                                    seconds = durationSeconds
                                }
                                let sDurationSeconds = Utility.formatSecondsToHMS(durationSeconds)
                                var sSecounds = Utility.formatSecondsToHMS(seconds)
                                if sDurationSeconds.count >= 8 {
                                    sSecounds = Utility.formatSecondsToHMS(seconds, eStyle: .long)
                                }
                                if sDurationSeconds != "LIVE" {
                                    _control.playbackStyle(.VOD, progress: seconds, duration: durationSeconds)
                                    print("No LIVE")
                                } else {
                                    print(" LIVE")
                                    _control.playbackStyle(.Live, progress: seconds, duration: durationSeconds)
                                }
                            }
                        }
                    }
                    
                    if let _repeatPlayer = self.repeatPlayer {
                        _repeatPlayer.view.removeFromSuperview()
                        _repeatPlayer.view.translatesAutoresizingMaskIntoConstraints = false
                        self.addSubview(_repeatPlayer.view)
                        _repeatPlayer.delegate = self
                        self.bringSubviewToFront(_repeatPlayer.view)
                        _repeatPlayer.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                        _repeatPlayer.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                        _repeatPlayer.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                        _repeatPlayer.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                        if !self.isRepeating {
                            self.hideRepeat()
                        } else {
                            self.showRepeat()
                        }
                    }
                    
                    if let _coverImage = self.coverImage {
                        _coverImage.view.alpha = 0
                        _coverImage.view.isHidden = true
                    }
                    
                    // Player item is ready to play.
                    let interval = CMTime(seconds: 0.25, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                    timeObserver = self.avq?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] progressTime in
                        if let playbackLikelyToKeepUp = self?.avq?.currentItem?.isPlaybackLikelyToKeepUp {
                            if playbackLikelyToKeepUp == false {
                                self?.indicator?.delegate?.indicatorStatus(isLoading: true)
                            } else {
                                self?.indicator?.delegate?.indicatorStatus(isLoading: false)
                                self?.isLoading = false
                                DispatchQueue.main.async {
                                    if let isAutoPlay = self?.configure?.isAutoPlay, let isPlaying = self?.configure?.isPlaying {
                                        if !isAutoPlay || !isPlaying {
                                            self?.avq?.pause()
                                            self?.configure?.isAutoPlay = true
                                            if self?.showsCustomControls ?? false && !(self?.isRepeating ?? false) {
                                                self?.showControlUI()
                                            }
                                        } else if  (self?.isRepeating ?? false) {
                                            self?.avq?.pause()
                                            self?.hideControlUI()
                                            self?.showRepeat()
                                        }
                                    }
                                }
                            }
                        } else {
                            self?.indicator?.delegate?.indicatorStatus(isLoading: true)
                            self?.isLoading = true
                        }
                        
                        if self?.isPlaying ?? false, let currentTime = self?.avq?.currentTime().seconds {
                            self?.control?.playbackSession(self?.avq, didProgressTo: currentTime + 0.25)
                            self?.controlDelegate?.playbackSession(self?.avq, didProgressTo: currentTime + 0.25)
                        }
                    }
                    
                case .failed:
                    print("Player item failed. See error.")
                // Player item failed. See error.
                case .unknown:
                    print("Player item is not yet ready.")
                // Player item is not yet ready.
                @unknown default:
                    print("Player item is not yet ready. unknown default")
                }
            }
        }
        
    }
}

extension BBTVPlayeriOS: BBTVPlayeriOSRepeatDelegate {
    public func touchRepeat() {
        self.isRepeating = false
        self.hideRepeat()
        self.avq?.seek(to: .zero)
        self.avq?.play()
    }
}
