//
//  BBTVPlayeriOSBrightCove.swift
//  BBTVPlayeriOS
//
//  Created by Chanon Purananunak on 22/6/2563 BE.
//

import AVFoundation
import AVKit
import UIKit
import BrightcovePlayerSDK
import Just

public class BBTVPlayeriOSBrightCove: UIView {
    public var corePlayer: BBTVPlayeriOS?
    public var avQueuePlayer: AVQueuePlayer?
    fileprivate var playerItemContext: String = "playerItemContext"
    public var playerLayer: AVPlayerLayer?
    public var setLayoutSize: Bool = false
    public var configure: BBTVPlayeriOSConfigure?
    public var bcService: BrightcoveServiceHelper?
    
    public init(playlistItemContext: String? = nil, avq: AVQueuePlayer? = nil, playerLayer: AVPlayerLayer? = nil, setLayoutSize: Bool? = nil, bcVideo: BCVideo?, configure: BBTVPlayeriOSConfigure?, service: BrightcoveServiceHelper?, core: BBTVPlayeriOS?){
        super.init(frame: .zero)
        
        if let avQueuePlayer = avq {
            self.avQueuePlayer = avQueuePlayer
        }
        
        if let playerLayer = playerLayer {
            self.playerLayer = playerLayer
        }
        
        if let setLayoutSize = setLayoutSize {
            self.setLayoutSize = setLayoutSize
        }
        
        if let corePlayer = core {
            self.corePlayer = corePlayer
        }
        
        if let configure = configure {
            self.configure = configure
        }
        
        if let service = service {
            self.bcService = service
        }
        
        if let bcVideo = bcVideo {
            self.bcVideo = bcVideo
            print("BCove: set bcVideo \(self.bcVideo)")
            self.vdoMetadata = self.bcVideo
            requestVideo()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: function from BBTVPlayerV2
    private var _siteId = "bugaboo"
    
    public var siteId: String? {
        get {
            return _siteId
        }
        set (newValue) {
            _siteId = newValue!
        }
    }
    public var video: BCOVVideo? {
        willSet {
            avQueuePlayer?.pause()
        }
        didSet {
            setVideo(with: video!)
        }
    }
    public var bcVideo: BCVideo? {
        didSet {
            //            print("BCove: set bcVideo \(bcVideo)")
            //            self.vdoMetadata = bcVideo
            //            requestVideo()
        }
    }
    
    func CreateDataParam(entryId: String, site: String) -> [String:String] {
        var data = ["":""]
        data["query"] = BBTVConfigConstants.query.rawValue
        data["operationName"] = BBTVConfigConstants.operationName.rawValue
        data["variables"] = "{\"site\": \"\(site)\", \"entry_id\":\"\(entryId)\"}"
        return data
    }
    
    func requestVideo() {
        print("BCove: requestVideo")
        switch self.bcVideo?.siteId {
        case "brightcove":
            let playbackService = BCOVPlaybackService(accountId: bcService?.accountId, policyKey: bcService?.policyKey)
            if let bcId = self.bcVideo?.bcId {
                playbackService?.findVideo(withVideoID: bcId, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
                    if let v = video {
                        self.bcovVideo = v
                        self.setVideo(with: self.bcovVideo!)
                    } else {
                        print("BBTVPlayeriOS V2 request-> " + (error?.localizedDescription ?? "Can't get BrightCove video"))
                        if error?.localizedDescription == kBCOVPlaybackServiceErrorKeyRawResponseData {
                            print("BBTVPlayeriOS V2 request-> kBCOVPlaybackServiceErrorKeyRawResponseData")
                        } else if error?.localizedDescription == kBCOVPlaybackServiceErrorKeyAPIErrors {
                            print("BBTVPlayeriOS V2 request-> kBCOVPlaybackServiceErrorKeyAPIErrors")
                        } else if error?.localizedDescription == kBCOVPlaybackServiceErrorKeyAPIHTTPStatusCode {
                            print("BBTVPlayeriOS V2 request-> kBCOVPlaybackServiceErrorKeyAPIHTTPStatusCode")
                        } else {
                            print("BBTVPlayeriOS V2 request-> \(error)")
                        }
                    }
                }
            } else {
                print("BBTVPlayeriOS V2 Can't get videos")
            }
            break
        default:
            let path = URL(string: BBTVConfigConstants.appsyncEndPoint.rawValue)
            let headers = ["x-api-key":BBTVConfigConstants.appsyncAuth.rawValue,
                           "Content-Type":RequestContentType.applicationJSON.rawValue]
            Just.post(path!,
                      data: CreateDataParam(entryId: self.bcVideo?.entryId ?? "", site: self.bcVideo?.siteId ?? "bugaboo"),
                      headers: headers) {
                        r in
                        if r.ok {
                            let gson = r.json as! [String : AnyObject]
                            if let gsonData = gson["data"] as? [String : AnyObject] {
                                if let playBackData = gsonData["Playback"] as? [String : AnyObject] {
                                    let videos = playBackData["videos"] as? [String : AnyObject]
                                    let hls = videos?["hls"] as? NSArray
                                    var aHLS: [Playback.Videos] = []
                                    for dataHLS in hls ?? [] {
                                        let data = dataHLS as? [String : AnyObject]
                                        let playBackData = Playback.Videos.init(title: data?["title"] as? String ?? "", type: data?["type"] as? String ?? "", src: data?["src"] as? String ?? "")
                                        aHLS.append(playBackData)
                                    }
                                    let dash = videos?["dash"] as? NSArray
                                    var aDash: [Playback.Videos] = []
                                    for dataDASH in dash ?? [] {
                                        let data = dataDASH as? [String : AnyObject]
                                        let playBackData = Playback.Videos.init(title: data?["title"] as? String ?? "", type: data?["type"] as? String ?? "", src: data?["src"] as? String ?? "")
                                        aDash.append(playBackData)
                                    }
                                    let videosHLSandDASH = Playback.Video(hls: aHLS, dash: aDash)
                                    let dcrGSON = playBackData["dcr"] as? [String : AnyObject]
                                    let metaDataGSON = dcrGSON?["metadata"] as? [String : AnyObject]
                                    let metaData = Playback.MEATDATA.init(type: metaDataGSON?["type"] as? String ?? "", assetid: metaDataGSON?["assetid"] as? String ?? "", isfullepisode: metaDataGSON?["isfullepisode"] as? String ?? "", program: metaDataGSON?["program"] as? String ?? "", title: metaDataGSON?["title"] as? String ?? "", crossId2: metaDataGSON?["crossId2"] as? String ?? "", airdate: metaDataGSON?["airdate"] as? String ?? "", adloadtype: metaDataGSON?["adloadtype"] as? String ?? "", hasAds: metaDataGSON?["hasAds"] as? String ?? "", vcid: metaDataGSON?["vcid"] as? String ?? "", site: metaDataGSON?["site"] as? String ?? "", segb: metaDataGSON?["segb"] as? String ?? "")
                                    let dcr = Playback.DCR.init(matadata: metaData)
                                    self.playBack = Playback(entryId: String(describing: playBackData["entry_id"]), title: playBackData["title"] as? String, thumb: playBackData["thumb"] as? String, contentUrl: playBackData["content_url"] as? String, videoBrightCoveId: playBackData["video_brightcove_id"] as? String, videos: videosHLSandDASH, dcr: dcr)
                                }
                            } else {
                                print("BBTVPlayeriOS V2 Can't get videos")
                            }
                            if self.playBack?.videoBrightCoveId != nil || self.playBack?.videos?.hls != nil {
                                self.tryGetVideo()
                            } else {
                                print("BBTVPlayeriOS V2 Can't get videos")
                            }
                        } else {
                            print("BBTVPlayeriOS V2 \(r.description)")
                        }
            }
            break
        }
    }
    
    func tryGetVideo() {
        let playbackService = BCOVPlaybackService(accountId: bcService?.accountId, policyKey: bcService?.policyKey)
        if let bcId = playBack?.videoBrightCoveId, !(playBack?.videoBrightCoveId?.isEmpty)! {
            playbackService?.findVideo(withVideoID: bcId, parameters: nil) { (video: BCOVVideo?, jsonResponse: [AnyHashable: Any]?, error: Error?) -> Void in
                if let v = video {
                    self.bcovVideo = v
                    self.setVideo(with: self.bcovVideo!)
                } else {
                    print("BBTVPlayeriOS V2 Can't get BrightCove videos") 
                }
            }
        } else {
            if let video = self.createVideo(self.playBack!) {
                if video != nil {
                    self.bcovVideo = video
                    self.setVideo(with: bcovVideo!)
                } else {
                    print("BBTVPlayeriOS V2 Can't get BrightCove videos")
                }
            }
        }
    }
    
    func createVideo(_ playback: Playback) -> BCOVVideo? {
        guard let videos = playback.videos?.hls
            else {
                //TODO: handle error
                print(("BBTVPlayeriOS: (info) NAT createVideo \"no source video\"" ))
                print("BBTVPlayeriOS V2 Can't get BrightCove videos")
                return nil
        }
        if videos.count > 0 {
            var src: String? = ""
            for video in videos {
                if video.title == "480p" {
                    src = video.src
                }
            }
            if src == "" {
                src = videos.last?.src
                let url = URL(string: src ?? "")!
                var vdo = BCOVVideo(url: url, deliveryMethod: kBCOVSourceDeliveryHLS)!
                guard  let title = playback.title,
                    let metadata = playback.dcr?.matadata
                    else {
                        return vdo
                }
                vdo = self.updateVideoProperties(video: vdo, forKey: "name", value: title)
                vdo = self.updateVideoProperties(video: vdo, forKey: "custom_fields", value: metadata.dictionary)
                return vdo
            } else {
                let url = URL(string: src ?? "")!
                var vdo = BCOVVideo(url: url, deliveryMethod: kBCOVSourceDeliveryHLS)!
                guard  let title = playback.title,
                    let metadata = playback.dcr?.matadata
                    else {
                        return vdo
                }
                vdo = self.updateVideoProperties(video: vdo, forKey: "name", value: title)
                vdo = self.updateVideoProperties(video: vdo, forKey: "custom_fields", value: metadata.dictionary)
                return vdo
            }
        } else {
            return nil
        }
    }
    
    let sharedSDKManager = BCOVPlayerSDKManager.shared()
    public var playbackController: BCOVPlaybackController!
    var vdoMetadata: BCVideo?
    var isPlaylist: Bool = false
    var playBack: Playback?
    var bcovVideo: BCOVVideo?
 
    func setVideo(with video: BCOVVideo) {
        if let videoURL = URL(string: video.sources[0].url.absoluteString ?? "") {
            let assetKeys = [
                "playable",
                "hasProtectedContent"
            ]
            let asset = AVAsset(url: videoURL)
            let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: assetKeys)
            
            playerItem.addObserver(self.corePlayer!, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            playerItem.addObserver(self.corePlayer!, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            playerItem.addObserver(self.corePlayer!, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            playerItem.addObserver(self.corePlayer!, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: &corePlayer!.playerItemContext)
            print("self.player0003: ")
            let avq_player = AVQueuePlayer(playerItem: playerItem)
            self.corePlayer?.avPlayerItems.append(playerItem)
            self.avQueuePlayer = avq_player
            self.corePlayer?.avq = self.avQueuePlayer
            self.corePlayer?.avq?.play()
            
            print("BBTVPlayerV2 add layer")
            if let avq_player = self.corePlayer?.avq {
                corePlayer?.playerLayer = AVPlayerLayer(player: avq_player)
                if let _playerLayer = corePlayer?.playerLayer {
                    _playerLayer.videoGravity = .resize
                    corePlayer?.layer.sublayers?
                        .filter { $0 is AVPlayerLayer }
                        .forEach { $0.removeFromSuperlayer()
                    }
                    if let superview = corePlayer?.superview {
                        print("BBTVPlayerV2 superview \(superview)")
                        _playerLayer.frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: superview.frame.height)
                        self.setLayoutSize = true
                    }
                    corePlayer?.layer.addSublayer(_playerLayer)
                }
            }
            
        }
    }
 
    func updateVideoProperties(video: BCOVVideo,  forKey key: String, value: Any ) -> BCOVVideo {
        return video.update({ (mutableVideo) in
            var propertiesToUpdate = mutableVideo?.properties
            _ = propertiesToUpdate?.updateValue(value, forKey: key)
            mutableVideo?.properties = propertiesToUpdate
        })
    }
}
