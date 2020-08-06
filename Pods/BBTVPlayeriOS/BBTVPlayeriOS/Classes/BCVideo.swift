//
//  BCVideo.swift
//  BBTVPlayeriOS
//
//  Created by Wiwat Patanaprasitchai on 28/5/2562 BE.
//  Implemented by Chanon Purananunak on 12/6/2563 BE.
//

import Foundation
import BrightcovePlayerSDK

enum RequestContentType: String {
    case applicationJSON = "application/json"
    case applicationURLEncoded = "application/x-www-form-urlencoded"
}

enum BBTVConfigConstants: String {
    case appsyncEndPoint = "https://mlf3bqmq7vfcnfkrk5weaq2oqq.appsync-api.ap-southeast-1.amazonaws.com/graphql"
    case appsyncAuth = "da2-j4e6mkdzj5eurjdmqejlpixmiu"
    case apiPath = "https://app.bug-a-boo.tv/bugaboo/api/v3"
    case Authorization = "Basic YnVnYWJvb19pb3M6ZDkxNDkxYzEtYjk3NC00YTIxLWExYjUtMzk4YzAwYTkwNmQy"
    case query = "query Playback($site: String!, $entry_id: String!) {Playback(site: $site, entry_id: $entry_id) { entry_id title thumb content_url video_brightcove_id videos { hls { title type src } dash { title type src }}dcr { metadata { type assetid isfullepisode program title crossId2 airdate adloadtype hasAds vcid site segb }}} }"
    case operationName = "Playback"
}

public struct bcVariables {
    let site: String?
    let entryId: String?
}

public class BBTVPlayerAdsEntry {
    public var adsType: String?
    public var adsTag: String?
    
    public init(adsType: String? = nil, adsTag: String? = nil) {
        self.adsTag = adsTag
        self.adsType = adsType
    }
}

public class BrightcoveServiceHelper {
    public var accountId: String?
    public var policyKey: String?
    
    public init(accountId: String? = nil ,  policyKey: String? = nil ) {
        self.accountId = accountId
        self.policyKey = policyKey
    }
}

public class BCVideo {
    public var siteId: String?
    public var entryId: String?
    public var siteName: String?
    public var seekTo: CMTime?
    public var bcId: String?
    
    public init(siteId: String, contentId: String, siteName: String, videoId: String) {
        self.siteId = siteId
        self.entryId = contentId
        self.siteName = siteName
        self.bcId = videoId
    }
    
    public init(siteId: String? = "bugaboo" ,  entryId: String? = nil) {
        self.siteId = siteId
        self.entryId = entryId
    }
    
    public init(siteId: String? = "bugaboo" ,  entryId: String? = nil, bcId: String? = nil) {
        self.siteId = siteId
        self.entryId = entryId
        self.bcId = bcId
    }
    
    public init(siteId: String? = "bugaboo" ,  entryId: String? = nil, siteName: String? = nil) {
        self.siteId = siteId
        self.entryId = entryId
        self.siteName = siteName
    }
    
    public init(siteId: String? = "bugaboo" ,  entryId: String? = nil, siteName: String? = nil, bcId: String? = nil) {
        self.siteId = siteId
        self.entryId = entryId
        self.siteName = siteName
        self.bcId = bcId
    }
    
    public init(siteId: String? = "bugaboo" ,  entryId: String? = nil, siteName: String? = nil , seekTo: CMTime?) {
        self.siteId = siteId
        self.entryId = entryId
        self.siteName = siteName
        self.seekTo = seekTo
    }
}

public class Playback {
    public var entryId: String?
    public var title: String?
    public var thumb: String?
    public var contentUrl: String?
    public var videoBrightCoveId: String?
    public var videos: Video?
    public var dcr: DCR?
    
    public init(entryId: String? = nil,
                title: String? = nil,
                thumb: String? = nil,
                contentUrl: String? = nil,
                videoBrightCoveId: String? = nil,
                videos: Video? = nil,
                dcr: DCR? = nil) {
        self.entryId = entryId
        self.title = title
        self.thumb = thumb
        self.contentUrl = contentUrl
        self.videoBrightCoveId = videoBrightCoveId
        self.videos = videos
        self.dcr = dcr
    }
    
    // Structor
    public struct Video {
        public let hls: [Videos]
        public let dash: [Videos]
    }
    public struct Videos {
        public let title: String
        public let type: String
        public let src: String
    }
    public struct DCR {
        public let matadata: MEATDATA
    }
    public struct MEATDATA {
        public let type: String
        public let assetid: String
        public let isfullepisode: String
        public let program: String
        public let title: String
        public let crossId2: String
        public let airdate: String
        public let adloadtype: String
        public let hasAds: String
        public let vcid: String
        public let site: String
        public let segb: String
        
        var dictionary: [AnyHashable: Any] {
            return ["type": type,
                    "assetid": assetid,
                    "isfullepisode": isfullepisode,
                    "program": program,
                    "title": title,
                    "crossId2": crossId2,
                    "airdate": airdate,
                    "adloadtype": adloadtype,
                    "hasAds": hasAds,
                    "vcid": vcid,
                    "site": site,
                    "segb": segb]
        }
        var nsDictionary: NSDictionary {
            return dictionary as NSDictionary
        }
    }
}

