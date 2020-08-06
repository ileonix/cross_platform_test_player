//
//  BBTVPlayeriOSDRM.swift
//  BBTVPlayeriOS
//
//  Created by Chanon Purananunak on 25/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit

public class BBTVPlayeriOSDRM: UIView {
    public var corePlayer: BBTVPlayeriOS?
    public var playerLayer: AVPlayerLayer?
    public var setLayoutSize: Bool = false
    public init(core: BBTVPlayeriOS? = nil, isNewAsset: Bool? = nil, srcDrm: String? = nil, playerLayer: AVPlayerLayer? = nil, setLayoutSize: Bool? = nil){
        super.init(frame: .zero)
        if let core = core {
            self.corePlayer = core
            
            if let playerLayer = playerLayer {
                self.playerLayer = playerLayer
            }
            
            if let setLayoutSize = setLayoutSize {
                self.setLayoutSize = setLayoutSize
            }
            
            if let isNewAsset = isNewAsset {
                self.isNewAsset = isNewAsset
                if let srcDrm = srcDrm {
                    print("DRM: 1 init srcDrm")
                    self.srcDrm = srcDrm
                    self.loadContent()
                }
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    @objc open var srcDrm: String? {
        didSet {
            print("DRM: 1 srcDrm")
        }
    }
    
    @objc
    open var site: String = "bugaboo"
    
    var item: [String:Any]?
    var streamURLs: [[String:Any]]?
    var asset: Asset?
    var metadata: [String:Any]?
    var drm: [String:Any]?
    
    var timeObserverToken: Any?
    var isNewAsset: Bool = true
    var isSeeking: Bool = false
    var activePlayer: ActivePlayer = .unknown
    
    //MARK: Request
    func request(stream: [String: Any]?){
        print("DRM: 3 request 1 \(self.srcDrm)")
        let assetName =  "" //stream?["title"] as! String
        //let src = String(self.srcDrm!) //"https://d3lau8zyhtlzx2.cloudfront.net/livech7/smil:livech7.smil/playlist.m3u8"//stream?["src"] as! String //.m3u8
        
        if let src = self.srcDrm {
            print("DRM: 3 request 2 \(src)")
            let accessToken = Utility.accessToken()
            let url = "\(src)"
            
            if let streamURL = URL(string:url) {
                print("DRM: 3 request 3 \(streamURL.absoluteString)")
                let avURLAsset = AVURLAsset(url: streamURL)
                self.prepareForDRM()
                self.asset = Asset(name: assetName, urlAsset: avURLAsset, resourceLoaderDelegate: AssetLoaderDelegate(asset: avURLAsset, assetName: assetName))
                let requestedKeys = ["playable" ,"duration"]
                avURLAsset.loadValuesAsynchronously(forKeys: requestedKeys, completionHandler: {
                    DispatchQueue.main.async {
                        print("DRM: 3 request 4 \(avURLAsset) \(requestedKeys[0])")
                        self.prepareToPlayAsset(asset: avURLAsset, requestedKeys: requestedKeys)
                    }
                })
            } else {
                print("DRM: 3 request 3 did if let nil self.srcDrm \(self.srcDrm)")
            }
        }
    }
    
    //MARK: prepareToPlayAsset
    func prepareToPlayAsset(asset: AVURLAsset, requestedKeys:Array<Any>)  {
        print("DRM: 5 prepareToPlayAsset 1 \(asset)")
        for key in requestedKeys {
            print("DRM: 5 prepareToPlayAsset 2 \(key)")
            var error: NSError? = nil
            let status: AVKeyValueStatus = asset.statusOfValue(forKey: key as! String, error: &error)
            if status == .failed {
                self.assetFailedToPrepareForPlayback(error: error!)
                return
            }
        }
        
        if !asset.isPlayable {
            print("DRM: 5 prepareToPlayAsset 3 \(asset.isPlayable)")
            let errorDict = [
                NSLocalizedDescriptionKey:"Item cannot be played",
                NSLocalizedFailureReasonErrorKey:"The assets tracks were loaded, but could not be made playable."
            ]
            let error: NSError  = NSError(domain: "BBTVPlayerKit", code: 0, userInfo: errorDict)
            self.assetFailedToPrepareForPlayback(error: error )
            return
        }
        
        if self.corePlayer?.avq?.currentItem != nil {
            print("DRM: 5 prepareToPlayAsset 4 \(self.corePlayer?.avq?.currentItem)")
            self.corePlayer?.avq?.currentItem?.removeObserver(self.corePlayer!, forKeyPath: BBTVPlayeriOS.ObserverContexts.playerItemStatusKey)
            
            NotificationCenter.default.removeObserver(self.corePlayer, name: .AVPlayerItemDidPlayToEndTime, object: self.corePlayer?.avq?.currentItem)
        }
        
        let playerItem = AVPlayerItem(asset:asset)
        playerItem.addObserver(self.corePlayer!, forKeyPath: BBTVPlayeriOS.ObserverContexts.playerItemStatusKey, options: [.initial,.new], context: &BBTVPlayeriOS.ObserverContexts.playerItemStatus)
        playerItem.addObserver(self.corePlayer!, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &corePlayer!.playerItemContext)
        print("DRM: 5 prepareToPlayAsset 5 ", self.corePlayer?.avq)
        NotificationCenter.default.addObserver(self.corePlayer, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: self.corePlayer?.avq?.currentItem)
        self.loadStream(playerItem: playerItem)
    }
    
    //MARK: Asset failed to prepare for playback
    func assetFailedToPrepareForPlayback(error:Error)  {
        print("DRM: assetFailedToPrepareForPlayback 1 \(error.localizedDescription)")
        self.showAlert(title: "ข้อผิดพลาด", message: error.localizedDescription)
    }
    
    //MARK: Load stream
    private func loadStream( playerItem: AVPlayerItem)  {
        print("DRM: 6 loadStream 1 \(playerItem)")
        let currentTime = self.corePlayer?.avq?.currentTime()
        let duration = self.corePlayer?.avq?.currentItem?.duration
        self.corePlayer?.avq?.replaceCurrentItem(with: playerItem)
        
        if self.isNewAsset {
            print("DRM: 6 loadStream 2 \(isNewAsset)")
            self.corePlayer?.avq?.play()
        }else{
            if (duration?.isIndefinite)! {
                print("DRM: 6 loadStream LIVE")
                // for live
                self.corePlayer?.avq?.play()
            }else {
                print("DRM: 6 loadStream VOD")
                // for vod
                let timeScale = playerItem.asset.duration.timescale
                let time = CMTime(seconds: (currentTime?.seconds)!, preferredTimescale:timeScale )
                self.isSeeking = true
                self.corePlayer?.avq?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero )
            }
        }
        
        //MARK: Add PlayerLayer
        if let avq_player = self.corePlayer?.avq {
            print("DRM: 6 loadStream Add PlayerLayer")
            corePlayer?.playerLayer = AVPlayerLayer(player: avq_player)
            if let _playerLayer = corePlayer?.playerLayer {
                _playerLayer.videoGravity = .resize
                corePlayer?.layer.sublayers?
                    .filter { $0 is AVPlayerLayer }
                    .forEach { $0.removeFromSuperlayer()
                }
                if let superview = corePlayer?.superview {
                    print("DRM: superview \(superview)")
                    _playerLayer.frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height)
                    self.setLayoutSize = true
                }
                corePlayer?.layer.addSublayer(_playerLayer)
            }
        }
        
    }
    
    //MARK: Change Quality
    func changeQuality(stream: [String: Any]?)  {
        print("DRM: changeQuality")
        self.corePlayer?.avq?.pause()
        self.isNewAsset = false
        self.request(stream: stream )
    }
    
    //MARK: Load content
    func loadContent()  {
        print("DRM: 2 loadContent")
        
        guard srcDrm != nil else {
            return
        }
        
        do {
            //TODO : handle error
            
            // videos
            if let videos = self.item?["videos"] as? [String : Any] {
                print("DRM: 2 loadContent 1 videos: \(videos.count)")
                if let hls   = videos["hls"] as? [[String : Any]] {
                    print("DRM: 2 loadContent 2 hls: \(hls.count)")
                    self.streamURLs = hls
                }
            }
            
            // drm
            if let drm = self.item?["drm"] as? [String : Any]   {
                print("DRM: 2 loadContent 3 drm: \(drm.count)")
                self.drm = drm
            }
            DispatchQueue.main.async {
                print("DRM: 2 loadContent 4 self.request")
                self.request(stream:  self.streamURLs?.last )
            }
            
        } catch {
            print("DRM: 2 loadContent 5 error")
            self.showAlert(title: "ข้อความ", message: "พบข้อผิดพลาดกรุณาลองใหม่อีกครั้ง")
        }
    }
    
    //MARK: Show Quality
    func showQuality(sender:Any?)  {
        print("DRM: showQuality")
        guard streamURLs != nil else {
            return
        }
        
        let alert  = UIAlertController(title: "QUALITY", message: nil, preferredStyle: .actionSheet)
        weak var weakSelf = self
        for streamURL in streamURLs! {
            let title = streamURL["title"] as? String
            let itemAction = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                weakSelf?.changeQuality(stream: streamURL)
            })
            alert.addAction(itemAction)
        }
        
        let calcelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(calcelAction)
        
        if let popoverPresentationController = alert.popoverPresentationController {
            let button = sender as? UIView
            popoverPresentationController.sourceView = self.corePlayer
            popoverPresentationController.sourceRect = self.corePlayer!.convert((button?.frame)!, to: self.corePlayer)
        }
        
        //        self.corePlayer!.superview?.superclass.present(alert, animated: true, completion: nil);
    }
    
    //MARK: Add player observer
    func addPlayerObservers()   {
        print("DRM: addPlayerObservers \(self.corePlayer?.avq)")
        guard let player = self.corePlayer?.avq else {
            return
        }
    }
    
    //MARK: Remove player item observer
    func removePlayerObservers(){
        print("DRM: removePlayerObservers \(self.corePlayer?.avq)")
        guard let player = self.corePlayer?.avq else {
            return
        }
    }
    
    //MARK: Add player item observer
    func addPlayerItemObservers(playerItem: AVPlayerItem?)  {
        print("DRM: addPlayerItemObservers \(playerItem)")
        guard let playerItem = playerItem else {
            return
        }
        //PlayerItem
        playerItem.addObserver(self.corePlayer!, forKeyPath: BBTVPlayeriOS.ObserverContexts.playerItemStatusKey , options: .new, context: &BBTVPlayeriOS.ObserverContexts.playerItemStatus)
    }
    
    //MARK: Remove player item observer
    func removePlayerItemObservers(playerItem: AVPlayerItem?)  {
        print("DRM: removePlayerItemObservers \(playerItem)")
        guard let playerItem = playerItem else {
            return
        }
        //PlayerItem
        playerItem.removeObserver(self.corePlayer!, forKeyPath: BBTVPlayeriOS.ObserverContexts.playerItemStatusKey)//(self.corePlayer?.observerContexts_playerItemStatusKey)!)
    }
    
    //MARK: Add notification center
    func addNotificationCenter()  {
        print("DRM: addNotificationCenter ")
        NotificationCenter.default.addObserver(self.corePlayer, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self.corePlayer, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: Remove notification center
    open func removeNotificationCenter()  {
        print("DRM: removeNotificationCenter ")
        NotificationCenter.default.removeObserver(self.corePlayer)
    }
    
    //MARK: ItemReachEnd
    @objc func playerItemDidReachEnd(notification: Notification)  {
        if ((notification.object as? AVPlayerItem) == self.corePlayer?.avq?.currentItem) {
            print("DRM: playerItemDidReachEnd ")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kBBTVPlayerKitPlayerItemDidReachEnd") , object: nil)
        }
    }
    
    //MARK: EnterBackground
    @objc func applicationDidEnterBackground(){
        print("DRM: [DCR] applicationDidEnterBackground")
        switch activePlayer {
        case .content:
            self.corePlayer?.avq?.pause()
            break
        default:
            break
        }
    }
    
    //MARK: EnterForeground
    @objc func applicationWillEnterForeground(){
        print("DRM: [DCR] applicationWillEnterForeground")
        
        switch activePlayer {
        case .content:
            self.corePlayer?.avq?.play()
            break
        default:
            break
        }
    }
    
    //MARK: SHOW ALERT FUNC
    func showAlert(title: String, message: String){
        //        DispatchQueue.main.async {
        //            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //            alert.addAction(defaultAction)
        //            self.superview?.superclass.present(alert, animated: true, completion: nil)
        //        }
    }
    
    //MARK: - DRM
    func prepareForDRM(){
        print("DRM: 4 prepareForDRM 1")
        guard self.drm != nil else {
            return
        }
        
        if let allowsExternalPlayback = self.drm?["allowsExternalPlayback"] as? Bool  {
            print("DRM: 4 prepareForDRM 2 \(allowsExternalPlayback)")
            self.corePlayer?.avq?.allowsExternalPlayback = allowsExternalPlayback
        }
        
    }
    //MARK: End function from BBTVPlayerKit
}
