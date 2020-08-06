//
//  PlaylistModel.swift
//  BBTVPlayeriOS_Example
//
//  Created by Chanon Purananunak on 10/6/2563 BE.
//  Copyright © 2563 CocoaPods. All rights reserved.
//

import Foundation

struct SampleResponseData: Codable {
    let samples: [samples]
}

struct samples: Codable {
    let items: [items]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct items: Codable {
    let name, coverUrl, uri, drm_scheme, drm_license_url, `extension`: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case coverUrl
        case uri
        case drm_scheme
        case drm_license_url
        case `extension`
    }
}

class ReadJSON {
    public static var samples: [samples]? {
        get {
            if let path = Bundle.main.path(forResource: "playlist", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let json = try JSONDecoder().decode(SampleResponseData.self, from: data)
                    //print("result json: \(json)")
                    return json.samples
                } catch {
                    // handle error
                    print("result error")
                    return nil
                }
            }else {
                print("result path not set")
            }
            
            return nil
        }
    }
}
