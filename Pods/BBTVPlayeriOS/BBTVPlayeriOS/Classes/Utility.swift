//
//  Utility.swift
//  BBTVPlayeriOS
//
//  Created by Pimmii on 28/4/2563 BE.
//

import Foundation
import AdSupport

class Utility: NSObject {
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    enum estyleHMS {
        case short
        case long
    }
    
    static func formatSecondsToHMS(_ seconds: Double, eStyle: estyleHMS? = .short) -> String {
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return "LIVE" // or do some error handling
        }
        let hours = Int(seconds / 3600)
        let mins = Int(seconds / 60) % 60
        let secs = Int(seconds) % 60
        var timesHMS: String = ""
        
        switch eStyle {
        case .short:
            if hours > 0 {
                timesHMS += ((hours<10) ? "0" : "") + String(hours) + ":"
            }
            break
        case .long:
            timesHMS += ((hours<10) ? "0" : "") + String(hours) + ":"
            break
        default:
            break
        }
        
        timesHMS += ((mins<10) ? "0" : "") + String(mins) + ":" + ((secs<10) ? "0" : "") + String(secs)
        
        return timesHMS
    }
    
    //MARK: from BBTVPlayerKit
    static func accessToken() -> String  {
        let appId = "123456789"
        let secretKey = "11d1d382544ae81c49eb2ac9db44e044"
        let timestamp = Int64(Date().timeIntervalSince1970)
        
        let token = "\(appId):\(timestamp):\(secretKey)"
        let hashToken = token.MD5
        let mode = 2
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let queryString = "app_id=\(appId)&access_token=\(hashToken!)&timestamp=\(timestamp)&mode=\(mode)&uuid=\(uuid!)"
        return queryString
    }
    
    
    static func replaceMacro(string:String) -> String {
        let screen = UIScreen.main.bounds;
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        let appBundleId = Bundle.main.bundleIdentifier!
        let appCategory = "Entertainment"
        let deviceId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        var gender = "unknow"
        var age = "unknow"
        
        let userDefaults = UserDefaults.standard;
        if let genderTmp = userDefaults.string(forKey: "gender") {
            gender = genderTmp
        }
        if let ageTmp = userDefaults.string(forKey: "age") {
            age = ageTmp
        }
        var width = screen.width
        var height = screen.height
        if height > width {
            width = screen.height
            height = screen.width
        }
        
        let macros: [[String:Any]] = [
            ["key" : "{width}", "value" : width ],
            ["key" : "{height}", "value" : height ],
            ["key" : "{appName}", "value" : appName ],
            ["key" : "{appBundleId}", "value" : appBundleId ],
            ["key" : "{appCategory}", "value" : appCategory ],
            ["key" : "{deviceId}", "value" : deviceId ],
            ["key" : "{gender}", "value" : gender ],
            ["key" : "{age}", "value" : age ]
        ]
        var replacedString = string
        for macro in macros {
            guard let key = macro["key"] as? String,
                let value = macro["value"] as? String
                else {
                    break
            }
            
            replacedString = replacedString.replacingOccurrences(of: key, with:  value)
        }
        
        return replacedString
        
    }
    static func thumbImageURL(site: String, path: String) -> String {
        var secretKey = "ch7"
        var imageURL = "http://api.ch7.com/images/thumb/index.php"
        
        if site == "ch7" {
            secretKey = "ch7"
            imageURL = "http://api.ch7.com/images/thumb/index.php"
            
        }else if site == "bugaboo" {
            secretKey = "bugaboo"
            imageURL = "http://api.bugaboo.tv/images/thumb/index.php"
        }
        
        let scale = Int( UIScreen.main.scale )
        let width = Int( UIScreen.main.bounds.size.width * 40) / 100
        let w = width * scale
        let data = (path == "" ? secretKey : path+secretKey )
        let md5 = data.MD5!
        let reverse = md5.reversed()
        //let  code = String(  describing: reverse )
        let encodeURL = "\(imageURL)?v=3&full=yes&code=\(String(reverse))&path=\(path)&width=\(w)&role=thumb&platform=ios".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodeURL
    }
    //MARK: End from BBTVPlayerKit
}
