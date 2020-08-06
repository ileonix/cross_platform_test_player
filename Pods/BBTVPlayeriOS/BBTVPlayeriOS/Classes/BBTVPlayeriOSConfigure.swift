//
//  BBTVPlayeriOSSetting.swift
//  BBTVPlayeriOS
//
//  Created by Banchai on 21/4/2563 BE.
//

import Foundation

public class BBTVPlayeriOSConfigure {
    public init(){}
    
    public init(drmItem: [String: Any?]? ) {
        if let drmItem = drmItem {
            self.drmItem = drmItem
            if let site = drmItem["site"] as? String {
                self.site = site
            }
            if let entry_id = drmItem["entry_id"] {
                self.contentId = entry_id
            }
        }
    }
    
    public init(url: String?) {
        if let url = url {
            self.url = url
        }
    }
    
    public init(srcDrm: String?) {
        if let srcDrm = srcDrm {
            self.srcDrm = srcDrm
        }
    }
    
    public var bcService: BrightcoveServiceHelper?
    public var bcVideo: BCVideo?
    
    //BrightCove
    public init(siteId: String, entryId: String, bcId: String, accountId: String, policyKey: String){
        self.bcService = BrightcoveServiceHelper(accountId: accountId, policyKey: policyKey)
        self.bcVideo = BCVideo(siteId: siteId, entryId: entryId, bcId: bcId)
    }
    //Non-BrightCove
    public init(siteId: String, entryId: String, accountId: String, policyKey: String){
        self.bcService = BrightcoveServiceHelper(accountId: accountId, policyKey: policyKey)
        self.bcVideo = BCVideo(siteId: siteId, entryId: entryId)
    }
    
    public var updateControlUIwork: DispatchWorkItem?
    public var coverImage: UIImage?
    public var speedRate: Float?
    public var url: String?
    public var names: [String] = []
    public var isFullScreenMode: Bool = false
    public var isPlaylistMode: Bool = false
    public var isAutoPlay: Bool = false
    public var isPlaying: Bool = false
    public var isAutoRepeat: Bool = false
    public var isRepeating: Bool = false
    public var isSeeking: Bool = false
    public var playlist: [String] = []
    public var playlistWithName: [String: String] = [:]
    public var isShowControl: Bool = false
    
    public var drmItem: [String: Any?]? = [:]
    public var site: String?
    public var contentId: Any?
    public var srcDrm: String?
    
    public var isDrmEnable: Bool = false
    deinit {
        if let _sUrl = url {
            print("Strong Url is:", _sUrl)
        }
        updateControlUIwork?.cancel()
    }
    
    public func setSpeedRate(_ speedRate: Float?) -> Self {
        
        if let speedRate = speedRate {
            self.speedRate = speedRate
        }
        return self
    }
    
    public func setCoverImage(_ coverImage: UIImage?) ->  Self {
        if let coverImage = coverImage {
            self.coverImage = coverImage
        }
        return self
    }
    
    public func setAutoPlay(_ isAutoPlay: Bool) -> Self {
        self.isAutoPlay = isAutoPlay
        self.isPlaying = isAutoPlay
        return self
    }
    
    public func setAutoRepeat(_ isAutoRepeat: Bool) -> Self {
        self.isAutoRepeat = isAutoRepeat
        return self
    }
    
    public func setShowControl(_ isShowControl: Bool) -> Self {
        self.isShowControl = isShowControl
        return self
    }
    
    public func setPlaylist(_ playlist: [String]) -> Self {
        self.playlist = playlist
        return self
    }
    
    public func build() -> Self {
        self.updateControlUIwork = DispatchWorkItem(block: {})
        return self
    }
    
    public func setSrcDrm(_ srcDrm: String) -> Self {
        self.srcDrm = srcDrm
        return self
    }
    
    public func setNames(_ names: [String]) -> Self {
          self.names = names
          return self
    }
    
    public func setUrl(_ url: String) -> Self {
        self.url = url
        return self
    }
    
    public func setPlaylistWithName(_ playlistWithName: [String: String]) -> Self {
        self.playlistWithName = playlistWithName
        return self
    }
 }
